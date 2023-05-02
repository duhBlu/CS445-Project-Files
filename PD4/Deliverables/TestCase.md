### Hello, thanks for reading me.

# 1. Black Box Test Cases (For ONE important use case)
##   Test Case 1: To verify that the user has access to the Add Task Screen.
        Step 1: Open the Task Hawk application

        Expected result: Home page display with the following UI
            - Top Bar
                - Light/Dark mode switch
            - Date bar
                - Current date, Weekly/Calendar switch view, Add Task button, Scrollable date bar 
            - Middle pane
                - Task list tiles associated with the selected day from the date bar
                - No Tasks to Display message if no tasks for the current day
            - Bottom
                - Task list manager button
            
<img src = Images/TC1%20step1.jpg alt= “” width=300>   

        Step 2: Click the '+' button on the top right of the Weekly or Monthly pages
        Expected result: A form with the following fields prompts the user to enter 'Task' data:
            - Title: Title of 'Task' 
            - Note/Description: Additional notes for 'Task'
            - Task List: Task list associated to 'Task'
            - Date: Date for 'Task'
            - Start Time: Time 'Task' starts
            - End Time: Time 'Task' ends
            - Reminder: Duration before notification sent before <Start Time>
            - Repeat: Daily, Weekly, Monthly recurrence options
            - Color: Task tile card displayed to the user

<img src = Images/TC1%20step2.jpg alt= “” width=300>    

<img src = Images/TC2%20step7b.jpg alt= “” width=300>     

        Step 3: Enter the following values into the fields, and verify functionality of fields:
            Title: "Task"
            Note: "Task notes"
            Task List: 'default'
            Date: <Current Date>
                - Verify on tap 'Calendar Icon', calendar form displays and the selected date is shown in the field when selected

- <img src = Images/TC1%20step3a.jpg alt= “” width=300>   
                
            Start Time: <Any Time>
                - Verify on tap 'Clock Icon', time picker displays and user can select time


- <img src = Images/TC1%20step3b.jpg alt= “” width=300>  

            End Time: <Any Time>
            Remind: <Any>
            Repeat: <Any except none>
            Color: <Any>

<img src = Images/TC1%20step3c.jpg alt= “” width=300>   

            Expected Result: The fields are filled in with the selected information
        
        Step 4: Click the '+' button
        Expected result:
            - The add task page is closed, user returned back to homescreen, and the task is added to the Weekly and Monthly pages on the date(s) <Current Date> and on the dates for the recurrence set (dailey, weekly, monthly)
<img src = Images/TC1%20step4a.jpg alt= “” width=300>

<img src = Images/TC1%20step4b.jpg alt= “” width=300 >
            

# 2. White Box Test Cases (For TWO important methods from a Control class)
    - With your white box testing, the goal is to test the internal implementation details. This can be more challenging depending on how you’re implementing things

## Test Case 2: To verify editing task updates the task details in the task cards.
    Step 1: Open the Task Hawk application.
    Expected result: Home page displays.

<img src = Images/TC2%20step1.jpg alt= “” width=300>     

    Step 2: Select the '+' button.
    Expected result: An Add Task form with the Task Fields displays and  prompts the user to enter 'Task' data

    
    Step 3: Enter the following fields into the form:
        Title: "Task"
        Note: "Task notes"
        Task List: 'default'
        Date: <Current Date>
        Start Time: '5:00 am'
        End Time: '7:00 am'
        Remind: '5'
        Repeat: 'Daily'
        Color: 'blue'

<img src = Images/TC2%20step3.jpg alt= “” width=300> 

    Step 4: Click the '+' button
    Expected result: the task should be added to the Home Page with the selected values

<img src = Images/TC2%20step4.jpg alt= “” width=300> 

    Step 5: Click the Task tile you just made
    Expected result: A bottom sheet should slide up from the bottom of the screen displaying the following buttons:
        - Task Completed, Edit Task, Delete Task, Close

<img src = Images/TC2%20step5.jpg alt= “” width=300> 

    Step 6: Select the Edit Task button.
    Expected result: Edit Task Screen displays with the current tasks details prefilled in the appropriate fields.
    ss 6(none)

    Step 7: Modify the form with the following new details for the task:
        Title: "Updated Task"
        Note: "Updated task notes"
        Task List: 'default'
        Date: <Current Date + 1>
        Start Time: '6:00 pm'
        End Time: '7:00 pm'
        Remind: '10'
        Repeat: 'Weekly'
        Color: 'orange'

        Expected result: The form should be filled with the updated task details.

<img src = Images/TC2%20step7a.jpg alt= “” width=300>

<img src = Images/TC2%20step7b.jpg alt= “” width=300>

    Step 8: Click the '+' button.
    Expected Result: The Edit Task Screen should close, and the selected task should be updated to display the changes made to the original task.
<img src = Images/TC2%20step8.jpg alt= “” width=300>

##    Test Case 3: To verify deleting a task removes the item from the associated screens:
        Step 1: Open the Task Hawk application.
        Expected result: Home page displays.

<img src = Images/TC3%20step1.jpg alt= “” width=300>

        Step 2: Click the '+' button.
            Expected result: An Add Task form with the Task Fields displays and prompts the user to enter 'Task' data


        Step 3: Enter the following fields into the form:
            Title: "Task"
            Note: "Task notes"
            Task List: 'default'
            Date: <Current Date>
            Start Time: '5:00 am'
            End Time: '7:00 am'
            Remind: '5'
            Repeat: 'Daily'
            Color: 'blue'

<img src = Images/TC3%20step3.jpg alt= “” width=300>

        Step 4: Click the '+' button
        Expected result: the task should be added to the Home Page with the selected values

<img src = Images/TC3%20step4.jpg alt= “” width=300>

        Step 5: Click the Task tile you just made
        Expected result: A bottom sheet should slide up from the bottom of the screen displaying the following buttons:
            - Task Completed, Edit Task, Delete Task, Close
<img src = Images/TC3%20step5.jpg alt= “” width=300>

        Step 6: Select the Delete Task button
        Expected result: The deleted task should be deleted from the associated views
<img src = Images/TC3%20step6.jpg alt= “” width=300>





