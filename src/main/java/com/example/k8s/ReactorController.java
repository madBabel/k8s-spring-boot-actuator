package com.example.k8s;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;


import java.util.HashMap;
import java.util.Map;

@RestController
public class ReactorController {

    @Value("${server.port}")
    private String serverPort;

    @Value("${app.reactor.name:Reactor One}")
    private String reactorName;


    @GetMapping("/reactor")
    public Map<String, String> getreactorInfo() {
        Map<String, String> response = new HashMap<>();
        response.put("reactor", reactorName);
        response.put("port", serverPort);
        return response;
    }

    @GetMapping("/reactor/crash")
    public ResponseEntity<?> crash() {
         System.err.println("💥 Reactor meltdown triggered! Will crash in 2 seconds...");
        // Lanzamos un hilo aparte para cerrar la app tras 2 segundos
        new Thread(() -> {
            try {
                Thread.sleep(2000);
                System.err.println("💥 Reactor meltdown! Application shutting down...");
                System.exit(1);
            } catch (InterruptedException ignored) {}
        }).start();

        return ResponseEntity.ok("OK: se romperá el reactor en 2 segundos");
    }
}
