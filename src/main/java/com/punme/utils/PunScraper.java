package com.punme.utils;

import java.io.IOException;
import java.io.InputStream;
import java.net.SocketTimeoutException;
import java.security.GeneralSecurityException;
import java.util.ArrayList;
import java.util.LinkedList;
import java.util.List;
import java.util.Random;

import org.apache.http.client.HttpClient;
import org.apache.http.impl.client.HttpClients;
import org.json.simple.JSONObject;

/**
 * Created by Tosha on 11/11/2016.
 */
import com.google.api.client.googleapis.auth.oauth2.GoogleCredential;
import com.google.api.client.googleapis.javanet.GoogleNetHttpTransport;
import com.google.api.client.http.HttpRequest;
import com.google.api.client.http.HttpRequestInitializer;
import com.google.api.client.http.HttpTransport;
import com.google.api.client.json.JsonFactory;
import com.google.api.client.json.jackson2.JacksonFactory;
import com.google.api.services.language.v1beta1.CloudNaturalLanguage;
import com.google.api.services.language.v1beta1.CloudNaturalLanguageScopes;
import com.google.api.services.language.v1beta1.model.AnnotateTextRequest;
import com.google.api.services.language.v1beta1.model.AnnotateTextResponse;
import com.google.api.services.language.v1beta1.model.Document;
import com.google.api.services.language.v1beta1.model.Features;
import com.google.api.services.language.v1beta1.model.Token;
import com.jaunt.Element;
import com.jaunt.Elements;
import com.jaunt.JauntException;
import com.jaunt.UserAgent;

public class PunScraper {
	private final CloudNaturalLanguage cloudNaturalLanguage;

	public PunScraper() throws IOException, GeneralSecurityException {

		InputStream credentialsJSON = PunScraper.class.getClassLoader().getResourceAsStream("googleCredentials.json");

		JsonFactory jsonFactory = JacksonFactory.getDefaultInstance();
		HttpTransport httpTransport = GoogleNetHttpTransport.newTrustedTransport();
		final GoogleCredential credential = GoogleCredential.fromStream(credentialsJSON)
				.createScoped(CloudNaturalLanguageScopes.all());
		cloudNaturalLanguage = new CloudNaturalLanguage.Builder(httpTransport, jsonFactory,
				new HttpRequestInitializer() {
					@Override
					public void initialize(HttpRequest request) throws IOException {
						credential.initialize(request);
						request.setConnectTimeout(7500);
					}
				}).setApplicationName("My First Project").build();
	}

	// generates url based on input query word
	private static String urlGenerator(String word) {
		URLBuilder url = new URLBuilder("http://punoftheday.com/cgi-bin/findpuns.pl?");
		url.appendQuery("q", word);
		url.appendQuery("opt", "text");
		url.appendQuery("submit", "+Go%21+");

		String finalUrl = url.toString();

		return finalUrl;
	}

	// returns the key terms located within the input phrase, based on part of
	// speech
	// and root location
	private List<String> keyTerms(String phrase) throws IOException, GeneralSecurityException {
		LinkedList<String> keyTerms = new LinkedList<>();
		HttpClient client = HttpClients.createDefault();

		// CloudNaturalLanguage cloudNaturalLanguage = new
		// CloudNaturalLanguage.Builder(
		// httpTransport, jsonFactory, credential).setApplicationName("My First
		// Project").build();
		AnnotateTextRequest request = new AnnotateTextRequest()
				.setDocument(new Document().setContent(phrase).setType("PLAIN_TEXT")).setFeatures(new Features()
						.setExtractSyntax(true).setExtractEntities(false).setExtractDocumentSentiment(false))
				.setEncodingType("UTF16");
		CloudNaturalLanguage.Documents.AnnotateText analyze = cloudNaturalLanguage.documents().annotateText(request);

		AnnotateTextResponse response = null;
		
		int count = 0;
		int maxTries = 3;
		while (true) {
			try {
				response = analyze.execute();
				break;
			} catch (Exception e) {
				System.err.println(e);
				if (++count == maxTries) return null;
			}
		}

		// System.out.println(response.toPrettyString());
		List<Token> tokens = response.getTokens();
		Token root = null;
		Token pObj = null;
		boolean seenOf = false;
		int pObjCount = 0;
		for (Token t : tokens) {
			if (t.getText().getContent().equals("of") && root != null) {
				seenOf = true;
			}
			if (t.getDependencyEdge().getLabel().equals("ROOT")) {
				root = t;
			} else if (t.getDependencyEdge().getLabel().equals("POBJ")) {
				pObjCount++;
				if (seenOf && pObjCount == 1)
					pObj = t;
				seenOf = false;
			} else if (t.getPartOfSpeech().getTag().equals("NOUN")) {
				keyTerms.add(t.getText().getContent());
			}
		}
		keyTerms.addFirst(root.getText().getContent());
		if (pObj != null)
			keyTerms.addFirst(pObj.getText().getContent());

		return keyTerms;
	}

	// finds the most significant word in a phrase and creates pun based on that
	// word
	// if most significant has no pun, continues onto other nouns in phrase
	public JSONObject findPunFromPhrase(String phrase) throws JauntException, IOException, GeneralSecurityException {
		List<String> keyTerms = keyTerms(phrase);

		if (keyTerms == null)
			return null;

		for (String word : keyTerms) {
			JSONObject punAndWord = scrapeWebsiteForWord(word);
			if (punAndWord == null)
				continue;
			// retrieve the pun
			String pun = (String) punAndWord.get("pun");
			// System.out.println(pun);
			if (pun == null)
				continue;
			else
				return punAndWord;
		}
		// if no pun was found for any of the words
		JSONObject noPunAvailable = new JSONObject();
		noPunAvailable.put("word", "N/A");
		noPunAvailable.put("pun", "Take a better picture");
		return noPunAvailable;
	}

	// returns pun related to word
	private static JSONObject scrapeWebsiteForWord(String word) throws JauntException {
		// System.out.println(word);
		String url = urlGenerator(word);
		UserAgent userAgent = new UserAgent();
		userAgent.settings.autoSaveAsHTML = true; // seemingly no effect
		try {
			userAgent.visit(url);
		} catch (Exception e) {
			System.out.println(e.getStackTrace());
		}

		// Element pun =
		// userAgent.doc.findFirst("<tr>").findFirst("<td>").nextSiblingElement();
		if (userAgent.doc.findFirst("<table>") == null)
			return null;
		Elements trElements = userAgent.doc.findFirst("<table>").findEvery("<tr>");

		ArrayList<String> puns = new ArrayList<String>();
		for (Element tr : trElements) {
			Element pun = tr.findFirst("<td>").nextSiblingElement();

			String corpus = pun.innerHTML();
			int length = corpus.length();
			boolean foundFirstSpace = false;
			boolean foundSecondSpace = false;
			for (int i = 1; i < length; i++) {
				if (corpus.charAt(i) == '<' && corpus.charAt(i - 1) == ' ') {
					foundFirstSpace = true;
				} else if (corpus.charAt(i) == '>' && corpus.charAt(i + 1) == ' ') {
					foundSecondSpace = true;
				}
				// can check here too
			}
			if (foundFirstSpace && foundSecondSpace) {
				puns.add(pun.innerText());
			}
		}

		Random rand = new Random();
		if (puns.size() == 0)
			return null;
		int random = rand.nextInt(puns.size());

		JSONObject punAndWord = new JSONObject();
		punAndWord.put("pun", puns.get(random));
		punAndWord.put("word", word);
		return punAndWord;
	}
	// public static void main(String[] args) throws JauntException,
	// IOException, GeneralSecurityException{
	// //String pun = scrapeWebsiteForWord("bottle");
	// //List<String> keyTerm = keyTerms("a man on a skateboard");
	// PunScraper scraper = new PunScraper();
	// String punFromPhrase = (String) scraper.findPunFromPhrase("a man standing
	// on a wii").get("pun");
	// System.out.println(punFromPhrase);
	// }
}