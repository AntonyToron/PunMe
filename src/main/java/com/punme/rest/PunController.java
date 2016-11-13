package com.punme.rest;

import org.json.simple.JSONObject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseStatus;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.multipart.MultipartFile;

import com.punme.utils.MSVision;
import com.punme.utils.PunScraper;

@RestController
public class PunController {

	@Autowired
	PunScraper scraper;
	@Autowired
	MSVision msvision;
	
	@RequestMapping(value = "/pun", method = RequestMethod.POST)
	public JSONObject pun(@RequestParam("file") MultipartFile file) {

		String phrase = msvision.getCaption(file);
		try {
			JSONObject pun = scraper.findPunFromPhrase(phrase);
			return pun;
		} catch (Exception e) {
			e.printStackTrace();
		}

		return null;
	}
	
	@RequestMapping("/test")
	public String test() {
		return "test";
	}
	
	@RequestMapping(value = "/")
	@ResponseStatus(value = HttpStatus.OK)
	public HttpStatus home() {
		return HttpStatus.OK;
	}
	

}
