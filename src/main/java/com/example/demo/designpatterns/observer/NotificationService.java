package com.example.demo.designpatterns.observer;

import java.util.ArrayList;
import java.util.List;

public class NotificationService {
    private static NotificationService instance;

    private final List<UserObserver> observers = new ArrayList<>();
    private final List<String> notifications = new ArrayList<>();

    private NotificationService() {}

    public static synchronized NotificationService getInstance() {
        if (instance == null) {
            instance = new NotificationService();
        }
        return instance;
    }

    public void addObserver(UserObserver observer) {
        observers.add(observer);
    }

    public void removeObserver(UserObserver observer) {
        observers.remove(observer);
    }

    public void notifyAllUsers(String message) {
        notifications.add(message); // store for later viewing
        for (UserObserver user : observers) {
            user.update(message);
        }
    }

    public List<String> getNotifications() {
        return notifications;
    }
}
