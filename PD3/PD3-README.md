### Hello, thanks for reading me.

note to team: I need to completely refactor the use case scenarios. There are currently much too many, 
              so I will need to spend some time consolidating the current use cases into maybe 4-5 scenarios.

# List of Tasks:

## 1. Complete Class Diagram:
        a. Map important classes from Analysis Model to Design Model
        b. Organize classes and their relationships
        
## 2. Complete Dynamic Model
    2. Complete Sequence Diagrams (Include remaining use cases):
        a. Update existing sequence diagrams based on additional analysis
        b. Create new sequence diagrams for remaining use cases
        c. Ensure all sequence diagrams represent the behavior of the application

    3. Complete State Chart Diagram:
        a. Update the state chart diagram to reflect user interface states
        b. Ensure the state chart diagram represents the application's user interface throughout
        c. Consider all possible user interactions and transitions between states
        d. Validate the state chart diagram with user scenarios or walkthroughs to ensure it represents the intended user experience


## 3. Complete User Interface (UI) Design
    ? - not sure if needed

## 4. System Architecture Justification:
    Finished = JT

## 5. Application Skeleton Code:
    1. Generate classes in the programming language based on the class diagram
        - Start by creating a skeleton code with the overall structure of the program, including classes and methods
    2. Organize classes into packages or modules based on their roles and responsibilities
    3. Create skeleton methods reflecting messages from the sequence diagrams
    4. Document classes and methods using appropriate documentation tools (e.g., JavaDoc)


# Updated Use Case Descriptions outline:
1. Manage Tasks
    - User can:
        - Create Tasks
        - Modify Tasks
        - Delete Task 
        - Mark as Complete 
        - Set due date
        - Assign Color             
        - Set Priority 
        - Set Recurrence 
        - Add Task To Task List

2. Task List Management
    - User can:
        - Create Task List
        - Edit Task List
        - Delete Task List
        - Set password

3. Task Viewing
    - User can:
        - Weekly View 
        - Calendar View
        - Task List Manager"Viewer"
        - Filter Tasks by Priority 

4. Password Protecting Task Lists
    - User can: 
        - Set pin number or password for task list
            - Prompted to re-enter the password to confirm
        - change password
            - Prompted to enter old password, then enter new password twice to confirm change
        - Remove password protection
            - Prompted to enter password to remove password

5. Importing and Exporting Task Lists
    - User can:
        - Import a task list
        - Export a task list



