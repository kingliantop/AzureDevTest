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
		
        String response = "<p>REST hostname is " + hostname + "</p>";
	response = response +"<p>Time: " + formattedDate + "</p>";
	response = response + "<p>Requests: " + count + "</p>";
	return response;
    }
}
