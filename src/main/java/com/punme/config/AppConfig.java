package com.punme.config;

import com.punme.utils.PunScraper;
import com.punme.utils.MSVision;

import java.io.IOException;
import java.security.GeneralSecurityException;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

@Configuration
public class AppConfig {

	@Bean
	public PunScraper PunScraper() throws IOException, GeneralSecurityException {
		return new PunScraper();
	}
	
	@Bean
	public MSVision MSVision() {
		return new MSVision();
	}
	
}
