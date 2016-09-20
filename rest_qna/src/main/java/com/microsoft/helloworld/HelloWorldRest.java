package com.microsoft.helloworld;

import java.text.SimpleDateFormat;
import java.util.Date;
import javax.ws.rs.GET;
import javax.ws.rs.Path;
import javax.ws.rs.Produces;
import javax.ws.rs.core.MediaType;

@Path("helloworld")
public class HelloWorldRest {

    static int count = 0;

    /**
     * Method handling HTTP GET requests. The returned object will be sent to
     * the client as "text/plain" media type.
     *
     * @return String that will be returned as a text/plain response.
     */
    @GET
    @Produces(MediaType.TEXT_PLAIN)
    public String ping() {
        count = count + 1;

        SimpleDateFormat formatter = new SimpleDateFormat("hh:mm:ss zzzz");
        String formattedDate = formatter.format(new Date());
        
 	String hostname = "";
	try {
            java.net.InetAddress addr = java.net.InetAddress.getLocalHost();
           hostname = addr.getHostName();
        } catch (java.net.UnknownHostException e) {
	    hostname = "Unknown";
	}
		
        String response = "<p>Sample quiz</p>";
//	response = response +"<p>Time: " + formattedDate + "</p>";
//	response = response + "<p>Requests: " + count + "</p>";
        response = response + "<br/><p>What color is the sky? </p>";
        response = response + "<br/><input type=\"radio\" name=\"skycolor\" value=\"blue\" > blue<br>";
        response = response + "<br/><input type=\"radio\" name=\"skycolor\" value=\"yellow\" > yellow<br>";
        response = response + "<br/><input type=\"radio\" name=\"skycolor\" value=\"red\" > red<br>";

	response = response + "<br/><p>Which is the best place to shop online? </p>";
        response = response + "<br/><input type=\"radio\" name=\"shop\" value=\"jet.com\" > jet.com<br>";
        response = response + "<br/><input type=\"radio\" name=\"shop\" value=\"target.com\" > target.com<br>";
        response = response + "<br/><input type=\"radio\" name=\"shop\" value=\"walmart.com\" > walmart.com<br>";

	response = response + "<br/><p>Is Azure better that AWS? </p>";
	response = response + "<br/><input type=\"radio\" name=\"azure\" value=\"Yes\" > Yes<br>";
        response = response + "<br/><input type=\"radio\" name=\"azure\" value=\"Yesss!\" > Yesss!<br>";
       

        
	return response;
    }
}
