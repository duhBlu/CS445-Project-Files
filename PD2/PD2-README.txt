Hello, thanks for reading me.

note: Additional descriptions PD2 requirements are in Project Manual 3.0 Alpha starting on page 12
      Also, when you, the group, reads this, feel free to write notes of your own if you have opinions on the things we need to turn in.


Requirements Analysis and Modeling Deliverable Elements:

I. Refine Use Case Model from PD1

    - Review and incorporate feedback from PD1
    - Validate and clarify requirements using the Use Case Model
    - Finalize the Use Case Diagram with clear definition of actors and use cases
    - Keep refining the Use Case Descriptions
    - Describe clearly the use case preconditions, flows of events, and alternative flows
    - Revisit Use Case Model to clarify and add details as the conceptual and dynamic models are built

    notes: 
    1. We should reconsider the entierty of the use case outline. It was hastely thrown together, but the functional requirements are  
        still under consideration. I'm not a huge fan of Importing/exporting files + merging calendar atm, 
        so maybe we eliminate that section or find another way to implement something similar. Feels like an unnecessary addition.

    2. For the use case diagram, we could combine some of the smaller elements into their larger whole use case.
        e.g. Instead of having use cases for every smaller function, like add, modify, delete, add to category, etc. We could combine
                groups of functions like those into a main use case like task management. This to avoid the spagetti looking 
                use case diagram we had for PD1.
    
    3. For the use case descriptions, we really need to refine what we have.
        - There's about 25 existing use case descriptions. We need to decide what exactly we will an will not be implementing.
        - For the ones we think should stay, we really need to refine essentially every section of the charts
            - The entire document was kinda quickly thrown together without too much thought into anything other than a rough outline.
            - The more detail the better!
            

II. Build the Conceptual Model 
    - Identify initial Entity, Boundary, and Control objects from Use Case Descriptions and terms in the Data Dictionary from PD1
    - Apply dependency stereotypes for Entity, Boundary, or Control classes based on class responsibilities
    - Create an early Conceptual Model Class Diagram
    - Identify associations, generalizations, and aggregations between classes and create an initial Class Diagram

    notes:
    1. This is similar to what we did for the Module 5 Quiz
    2. Chapter 13 in our book covered a lot of this material
        - He also have some extra material explaining the conceptual model in modules 4 and 5
    3. This is where we will figure out roughly how to structure our code, and various elements of our app.


III. Build the Dynamic Model

    - Model the interaction between Boundary, Control, and Entity classes from the Conceptual Model for each use case
    - Enact the flow of events in the Use Case Description
    - Specify messages and parameters passed between classes in Sequence Diagrams
    - Model the system behavior in a State Machine Diagram of UIs based on UI mockups developed in PD1
    - Refine and further specify the user interface design
    - Move back and forth between the Conceptual Model and the Dynamic Model to reveal additional attributes, operations, and relationships of classes

    notes:
    1. We'll need to model what we come up with in II. 



=== Deliverable Elements ===

 1. Final Use Case Model, including Use Case Diagram and Use Case Descriptions using the template from Canvas
 2. Conceptual Model Class Diagram
 3. Class Diagram
 4. Dynamic Model, including Sequence Diagrams for at least three to four use cases and a State Chart Diagram of UIs.

    notes:
