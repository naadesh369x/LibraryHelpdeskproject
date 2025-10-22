package com.example.demo.designpatterns.observer;


public class StudentUser implements UserObserver {
    private final String name;

    public StudentUser(String name) {
        this.name = name;
    }

    @Override
    public void update(String message) {
        System.out.println("📩 " + name + " received message: " + message);
    }

    @Override
    public String toString() {
        return name;
    }
}
