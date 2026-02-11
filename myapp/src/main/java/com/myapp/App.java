package com.myapp;

import com.sun.net.httpserver.HttpServer;
import java.io.OutputStream;
import java.net.InetSocketAddress;

public class App {
    public static void main(String[] args) throws Exception {
        HttpServer server = HttpServer.create(new InetSocketAddress(8080), 0);
        
        server.createContext("/", new com.sun.net.httpserver.HttpHandler() {
            @Override
            public void handle(com.sun.net.httpserver.HttpExchange exchange) throws java.io.IOException {
                String response = "Hello World from Efrat Hager!";
                exchange.sendResponseHeaders(200, response.length());
                OutputStream os = exchange.getResponseBody();
                os.write(response.getBytes());
                os.close();
            }
        });

        System.out.println("Server is starting on port 8080...");
        server.setExecutor(null); 
        server.start();
        
        System.out.println("Signal is Running. Waiting for pickup...");
    }
}
