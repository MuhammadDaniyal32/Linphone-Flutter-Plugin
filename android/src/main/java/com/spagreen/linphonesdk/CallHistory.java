package com.spagreen.linphonesdk;

import org.linphone.core.Call;

public class CallHistory {
    private String number;
    private int duration;
    private String status;
    private long date;

    public String getNumber() {
        return number;
    }

    public void setNumber(String number) {
        this.number = number;
    }

    public int getDuration() {
        return duration;
    }

    public void setDuration(int duration) {
        this.duration = duration;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public long getDate() {
        return date;
    }

    public void setDate(long date) {
        this.date = date;
    }

    @Override
    public String toString() {
        return "CallHistory{" +
                "number='" + number + '\'' +
                ", duration=" + duration +
                ", status=" + status +
                ", date=" + date +
                '}';
    }
}
