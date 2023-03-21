### Hello, thanks for reading me.

# Requirements Analysis and Modeling Deliverable Elements:

## === Deliverable Elements ===

### Use Case Model (Final)

    - Use Case Diagram - Jacob Thieret
    - Use Case Descriptions - Jacob Thieret and Adam Bowles
--------
### Conceptual Model Class Diagram - Sam Gullett
--------
### Class Diagram - Jacob Thieret
--------
### Dynamic Model
    - Sequence Diagrams - Sam Gullett
    - State Chart Diagram - Sam Gullett
_____________________

# I. Refine Use Case Model from PD1

    - Review and incorporate feedback from PD1
    - Validate and clarify requirements using the Use Case Model
    - Finalize the Use Case Diagram with clear definition of actors and use cases
    - Keep refining the Use Case Descriptions
    - Describe clearly the use case preconditions, flows of events, and alternative flows
    - Revisit Use Case Model to clarify and add details as the conceptual and dynamic models are built
    
    Finalized Outline for use case descritpions 
        1. Task Management
            1.1 Create Task 
            1.2 Modify Task 
            1.3 Delete Task 
            1.4 Mark as Complete 
            1.5 Set due date 
            1.6 Set reminder
            1.7 Notification Options 
            1.8 Assign Color             
            1.9 Set Priority 
            1.10 Set Recurrence 
            1.11 Add Task To Task List
        2. Task Viewing
            2.1 Weekly View 
            2.2 Calendar View
            2.3 Task List Manager"Viewer"
            2.4 Filter Tasks by Priority 
        3. Task List Management
            3.1 Create Task List
            3.2 Edit Task List
            3.3 Delete Task List
            3.4 Export Task List 
            3.5 Exported Files Encryption 
            3.6 Import Task List  
            3.7 Imported Files Decryption
            3.8 Password Protected Task Lists


# II. Build the Conceptual Model 
    - Identify initial Entity, Boundary, and Control objects from Use Case Descriptions and terms in the Data Dictionary from PD1
    - Apply dependency stereotypes for Entity, Boundary, or Control classes based on class responsibilities
    - Create an early Conceptual Model Class Diagram
    - Identify associations, generalizations, and aggregations between classes and create an initial Class Diagram

    notes:
    1. This is similar to what we did for the Module 5 Quiz
    2. Chapter 13 in our book covered a lot of this material
        - He also has some extra material explaining the conceptual model in modules 4 and 5
    3. This is where we will figure out roughly how to structure our code, and various elements of our app.


    **************
    Entity: Represents a concept or object in the problem domain that has a distinct identity and a state that can be stored and managed.
    Boundary: Represents a point of interaction between the system and its external environment, such as a user interface or an external system.
    Control: Represents a component that coordinates and manages the behavior of other components within the system, such as a controller or a service.
    **************

    Here's an example diagram of what we will need to create for our project(It will need to be made with some chart maker):


             <<Entity>>            <<Boundary>>           <<Control>>
           +---------------+     +-----------------+    +--------------------+
           |     Task      |     |Task Management  |    |Task Management     |
           +---------------+     |   Boundary      |    |   Control          |
           | TaskID        |<--->|                 |<-->|                    |
           | Title         |     | Task Mgmt UI(s) |    | createTask()       |
           | Description   |     |                 |    | modifyTask()       |
           | StartDate     |     |                 |    | deleteTask()       |
           | EndDate       |     |                 |    | categorizeTask()   |
           | Reminders     |     |                 |    | setDueDate()       |
           | Recurrence    |     |                 |    | setReminder()      |
           | Category      |     |                 |    | markComplete()     |
           | Completed     |     |                 |    | setPriority()      |
           +---------------+     +-----------------+    | setRecurrence()    |
                                                          +------------------+

             <<Entity>>            <<Boundary>>              <<Control>>
           +---------------+     +-------------------+     +-------------------+
           |   Category    |     |Category Management|     |Category Management|
           +---------------+     |    Boundary       |     |      Control      |
           | CategoryID    |<--->|Category Mgmt UI(s)| <-->|                   |
           | CategoryName  |     |                   |     | createCategory()  |
           | CategoryColor |     |                   |     | modifyCategory()  |
           +---------------+     |                   |     | deleteCategory()  |
                                 +-------------------+     | assignColor()     |
                                                            +------------------+

             <<Entity>>            <<Boundary>>           <<Control>>
           +---------------+     +-----------------+    +-------------------+
           |      User     |     |   Task Viewing  |    |    Task Viewing   |
           +---------------+     |    Boundary     |    |      Control      |
           | UserID        |<--->| Task View UI(s) |<-->|                   |
           | UserName      |     |                 |    | weeklyView()      |
           | UserEmail     |     |                 |    | calendarView()    |
           | UserPhone#    |     |                 |    | mergedView()      |
           +---------------+     |                 |    | filterByCategory()|
                                 +-----------------+    | filterByPriority()|
                                                        +-------------------+





# III. Build the Dynamic Model

    To build a dynamic model based on the conceptual model, you could follow these steps:

    1. Model the interaction between Boundary, Control, and Entity classes from the Conceptual Model for each use case:
        - For each use case, identify the Boundary, Control, and Entity classes involved and their interactions. 
        - Create a collaboration diagram or use case diagram to show the interaction between these classes.

    2. Enact the flow of events in the Use Case Description:
        - Create a sequence diagram for each use case to show the flow of events and messages between the Boundary, Control, and Entity classes.

    3. Specify messages and parameters passed between classes in Sequence Diagrams:
        - In the sequence diagram, specify the messages and parameters passed between the classes involved in the use case.

    4. Model the system behavior in a State Machine Diagram of UIs based on UI mockups developed in PD1:
        - Create a state machine diagram to show the behavior of the user interface. Use the UI mockups developed in PD1 as a basis for the state machine diagram.

    5. Refine and further specify the user interface design:
        - Refine the user interface design based on the state machine diagram and user feedback. Update the state machine diagram accordingly.

    6. Move back and forth between the Conceptual Model and the Dynamic Model to reveal additional attributes, operations, and relationships of classes:
        - As you refine the dynamic model, you may discover additional attributes, operations, and relationships of classes that were not evident in the conceptual model. 
        - Update the conceptual model as needed to reflect these changes. Repeat this process as necessary to refine both models.




