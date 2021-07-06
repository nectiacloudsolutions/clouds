global class UsersDataList {

    public string action;
    public string code;
    public string message;
    public List<User> userList;
    
    public static UsersDataList parse(String json) {
        return (UsersDataList) System.JSON.deserialize(json, UsersDataList.class);
	}
    
}