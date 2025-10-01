package com.example.demo.models;



public class Client {
    private String name;
    private String joinedAgo;

    public Client(String name, String joinedAgo) {
        this.name = name;
        this.joinedAgo = joinedAgo;
    }

    public String getName() { return name; }
    public String getJoinedAgo() { return joinedAgo; }
}
