import ballerina/file;
import ballerina/log;
import ballerina/io;
import ballerinax/kafka;

// Defines the record to bind the data.
type Employee record{
    int id;
    string name;
    int salary;
};

string LOCAL_PATH_A="/Users/pablosa/Mi unidad/src/ballerina/ballerina/usecases/csvkakfacsv/input-folder";

// The listener monitors any modifications done to a specific directory.
listener file:Listener inFolder = new ({
    path: LOCAL_PATH_A,
    recursive: false
});

// The directory listener should have at least one of these predefined resources.
service "localObserver" on inFolder {

    // This function is invoked once a new file is created in the listening directory.
    remote function onCreate(file:FileEvent m) {

        log:printInfo("Create: " + m.name);
        
        Employee[] readCsv = checkpanic io:fileReadCsv(m.name);

        log:printInfo("File Content: ");
        io:println(readCsv);
        
        kafka:Producer orderProducer= checkpanic new (kafka:DEFAULT_URL);
        foreach var empleado in readCsv {
            checkpanic orderProducer->send({
                topic: "test-topic",
               value: empleado
          });
        }
    }
    
    // This function is invoked once an existing file is deleted from the listening directory.
    remote function onDelete(file:FileEvent m) {
        log:printInfo("Delete- Do Nothing: " + m.name);
    }

    // This function is invoked once an existing file is modified in the listening directory.
    remote function onModify(file:FileEvent m) {
        log:printInfo("Modify: " + m.name);

        Employee[] readCsv = checkpanic io:fileReadCsv(m.name);

        log:printInfo("File content:");
        io:println(readCsv);

        kafka:Producer orderProducer= checkpanic new (kafka:DEFAULT_URL);
        foreach var empleado in readCsv {
            checkpanic orderProducer->send({
                topic: "test-topic",
               value: empleado
          });

        }

    }

}
