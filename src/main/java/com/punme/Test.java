//package com.punme;
//
//import java.io.File;
//import java.io.FileOutputStream;
//import java.net.URI;
//
//import org.apache.http.HttpEntity;
//import org.apache.http.HttpResponse;
//import org.apache.http.client.HttpClient;
//import org.apache.http.client.methods.HttpPost;
//import org.apache.http.client.utils.URIBuilder;
//import org.apache.http.entity.ContentType;
//import org.apache.http.entity.FileEntity;
//import org.apache.http.impl.client.HttpClients;
//import org.apache.http.util.EntityUtils;
//import org.json.simple.JSONArray;
//import org.json.simple.JSONObject;
//import org.json.simple.parser.JSONParser;
//
//public class Test {
//
//	
//	public static void main(String[] args) {
//		HttpClient httpclient = HttpClients.createDefault();
//
//		try {
//			URIBuilder builder = new URIBuilder("https://api.projectoxford.ai/vision/v1.0/describe");
//
//			builder.setParameter("maxCandidates", "1");
//
//			URI uri = builder.build();
//			HttpPost request = new HttpPost(uri);
//			request.setHeader("Content-Type", "application/octet-stream");
//			request.setHeader("Ocp-Apim-Subscription-Key", "f77b6e0423054da2b0dd4a614df9ade1");
//
//			// Request body
//			File f = new File("C:/Users/Frank Li/Desktop/d8ULKcu.jpg");
//			
//			FileEntity reqEntity = new FileEntity(f);			
//			request.setEntity(reqEntity);
//						
//			HttpResponse response = httpclient.execute(request);
//			HttpEntity entity = response.getEntity();
//
//			if (entity != null) {
//				String str = EntityUtils.toString(entity);
//				JSONParser parser = new JSONParser();
//				JSONObject json = (JSONObject) parser.parse(str);
//				
//				JSONObject description = (JSONObject) json.get("description");
//				JSONArray captions = (JSONArray) description.get("captions");
//				JSONObject firstCaption = (JSONObject) captions.get(0);
//				String phrase = (String) firstCaption.get("text");
//				
//				System.out.println(json);
//				System.out.println(phrase);
//			}
//		} catch (Exception e) {
//			System.out.println(e.getMessage());
//		}
//	}
//	
//	
//	
//}
