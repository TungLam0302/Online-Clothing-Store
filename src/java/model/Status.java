package model;

/**
 * Status model class representing order status
 */
public class Status {
    private int statusID;
    private String statusName;

    public Status() {
    }

    public Status(int statusID, String statusName) {
        this.statusID = statusID;
        this.statusName = statusName;
    }

    public int getStatusID() {
        return statusID;
    }

    public void setStatusID(int statusID) {
        this.statusID = statusID;
    }

    public String getStatusName() {
        return statusName;
    }

    public void setStatusName(String statusName) {
        this.statusName = statusName;
    }

    @Override
    public String toString() {
        return "Status{" + "statusID=" + statusID + ", statusName=" + statusName + '}';
    }
}
