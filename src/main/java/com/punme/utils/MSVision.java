package com.punme.utils;

import java.io.File;
import java.io.FileOutputStream;
import java.io.InputStream;
import java.net.URI;

import org.apache.http.HttpEntity;
import org.apache.http.HttpResponse;
import org.apache.http.client.HttpClient;
import org.apache.http.client.methods.HttpPost;
import org.apache.http.client.utils.URIBuilder;
import org.apache.http.entity.ContentType;
import org.apache.http.entity.FileEntity;
import org.apache.http.impl.client.HttpClients;
import org.apache.http.util.EntityUtils;
import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import org.springframework.web.multipart.MultipartFile;

public class MSVision {

	private String key;

	public MSVision() {

		InputStream mskey = MSVision.class.getClassLoader().getResourceAsStream("mskey.txt");
		try (java.util.Scanner s = new java.util.Scanner(mskey)) {
			key = s.useDelimiter("\\A").hasNext() ? s.next() : "";
		}
	}

	public String getCaption(MultipartFile file) {

		HttpClient httpclient = HttpClients.createDefault();

		try {
			URIBuilder builder = new URIBuilder("https://api.projectoxford.ai/vision/v1.0/describe");

			builder.setParameter("maxCandidates", "1");

			URI uri = builder.build();
			HttpPost request = new HttpPost(uri);
			request.setHeader("Content-Type", "application/octet-stream");
			request.setHeader("Ocp-Apim-Subscription-Key", key);

			// Request body
			File f = new File(file.getOriginalFilename());
			f.createNewFile();
			FileOutputStream fos = new FileOutputStream(f);
			fos.write(file.getBytes());
			fos.close();

			FileEntity reqEntity = new FileEntity(f, ContentType.MULTIPART_FORM_DATA);
			request.setEntity(reqEntity);

			HttpResponse response = httpclient.execute(request);
			HttpEntity entity = response.getEntity();

			f.delete();

			if (entity != null) {
				String str = EntityUtils.toString(entity);
				JSONParser parser = new JSONParser();
				JSONObject json = (JSONObject) parser.parse(str);

				JSONObject description = (JSONObject) json.get("description");
				JSONArray captions = (JSONArray) description.get("captions");
				JSONObject firstCaption = (JSONObject) captions.get(0);
				String phrase = (String) firstCaption.get("text");

				return phrase;
			}
		} catch (Exception e) {
			System.out.println(e.getMessage());
		}

		return null;
	}

}
