choice1 <- c("Student 1 Nothing","Student 1 Analog",
             "Student 1 Sm Individual","Student 1 Md Individual",
             "Student 1 Lg Individual","Student 1 Sm Group",
             "Student 1 Md Group","Student 1 Lg Group",
             "Student 1 Sm Class","Student 1 Md Class",
             "Student 1 Lg Class","Pause Time Student 1",
             "Unpause Time Student 1","End of Obs.")

choice2 <- c("Student 2 Nothing","Student 2 Analog",
             "Student 2 Sm Individual","Student 2 Md Individual",
             "Student 2 Lg Individual","Student 2 Sm Group",
             "Student 2 Md Group","Student 2 Lg Group",
             "Student 2 Sm Class","Student 2 Md Class",
             "Student 2 Lg Class","Pause Time Student 2",
             "Unpause Time Student 2","End of Obs.")

classes <- c("BB109","RB109","TC412","TC414","TC411")
courses <- c("BIO100","FCFN395","MATH181","JOUR348","ENG150","MATH125",
             "ENG103","SP102","NEWS221","FCFC265","HIST198","ISOM210",
             "MATH335","CS335","ENG150","MATH202","SOCW220","JOUR382",
             "CS120","MATH201","ENG444","MGT465","PEP310","ENG389")


#What fields we want to save from the form
fields1 <- c("studentID_DU1","course","RM_NUM","Semester","date")
fields2 <- c("studentID_DU2","course","RM_NUM","Semester","date")


#Creates the various functions needed to save and update the data
timer <- function(){
  return(as.integer(Sys.time()))
}

humanTime <- function() {
  format(Sys.time(), "%H:%M:%OS")
}


saveData1 <- function(data1) {
  data1 <- as.data.frame(t(data1))
  colnames(data1)[1] <-"studentID_DU"
  if (exists("response1")) {
    response1 <<- rbind(response1, data1)
  } else {
    response1 <<- data1
  }
}

saveData2 <- function(data2) {
  data2 <- as.data.frame(t(data2))
  colnames(data2)[1] <-"studentID_DU"
  if (exists("response2")) {
    response2 <<- rbind(response2, data2)
  } else {
    response2 <<- data2
  }
}

loadData1 <- function() {
  if (exists("response1")) {
    colnames(response1)[1] <-"studentID_DU"
    response1
  }
}

loadData2 <- function() {
  if (exists("response2")) {
    colnames(response2)[1] <-"studentID_DU"
    response2
  }
}

saveData <- function(data) {
  if (exists("response")) {
    response <<- rbind(response,data)
  } else {
    response <<- data
  }
}

loadData <- function() {
  if (exists("response")) {
    response
  }
}
