import ballerinax/kafka;
import ballerina/io;


// Defines the record to bind the data.
type Employee record{
    int id;
    string name;
    int salary;
};

string LOCAL_FILE_PATH_B="/Users/pablosa/Mi unidad/src/ballerina/ballerina/usecases/csvkakfacsv/output-folder/data-out.csv";

listener kafka:Listener orderListener = new (kafka:DEFAULT_URL, {
    groupId: "employee-group-id",
    topics: "test-topic"
});

service on orderListener {

    remote function onConsumerRecord(Employee[] employees) {
  
        io:println(employees);
        // Write a CSV file.
        checkpanic io:fileWriteCsv(LOCAL_FILE_PATH_B, employees, io:APPEND);

    }
}