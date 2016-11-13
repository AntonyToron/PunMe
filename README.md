# PunMe

## Overview

The PunMe app allows a user to take a photo or upload a photo and receive back a pun generated based on the subject of the photo.

## Mobile Application

The mobile application, built for iOS iPhone, iTouch and iPad in Swift 3, calls our API using the Alamofire networking framework and sends a photo in the form of a jpeg image, which the user can either take directly or select from his/her camera roll. From there, the app receives a JSON with a pun and a key word which appears in the pun, which is then displayed to the user along with the image. 

## Backend

Our backend server is a RESTful API built in Java Spring and deployed to Amazon Web Services using Boxfuse. When an image is received, it calls [Microsoft's Computer Vision API](https://www.microsoft.com/cognitive-services/en-us/computer-vision-api) which returns a caption describing the contents of the image, among other information about the image. We then use [Google's Cloud Natural Language Processing API](https://cloud.google.com/natural-language/) to determine the most important word in the caption, which is the direct subject of the image in one word. We then use this word to search [punoftheday.com](punoftheday.com) for puns relating to the subject of the image.

## Website

PunMe is available at [punme.net](punme.net).
