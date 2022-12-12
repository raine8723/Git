

#John Savill DevOps Master Class - Master Gis


#Check version
--------------------------------------------------------------------------------------------
git --version

#Turn any folder into a repo which creates a sub .git folder
--------------------------------------------------------------------------------------------
git init

#Set initial git configuration
--------------------------------------------------------------------------------------------
#Can replace --global with --local to set values for a specific repo if required
git config --global --list    #care about username and email

git config --global user.name "raine2703"
git config --global user.email raine2703@gmial.com

git config --list --show-origin      #see where coming from :q
git config --list

#Many other settings https://git-scm.com/book/en/v2/Getting-Started-First-Time-Git-Setup
git config --global init.defaultBranch main #this is very common to use instead of master#
-------------------------------------------------------------------------------------------

#push to existing github, first have to add remote origin, then pull/push.
git remote add origin https://github.com/raine2703/gitplay.git

#Looking at remote (again more later on all of this!)
git remote -v
git remote show origin

#Pull
git pull https://github.com/raine2703/test3.git
#If remote added, simply?
git pull

#Push 
git push -u origin main
#If remote added, simply?
git push
-------------------------------------------------------------------------------------------


#Function for nice git log command in Powershell
-------------------------------------------------------------------------------------------
function gitgraph {git log --oneline --graph --decorate --all}


#git add . and git commit
-------------------------------------------------------------------------------------------
code textfile.txt
git add .
git status
git diff --cached #Difference between staged and what is commited
git commit -m "Initial textfile.txt commit"


#NOTE Could combine the add and commit
git commit -am "Initial testfile.txt commit"
#or even
git commit -a -m "Initial testfile.txt commit"
-------------------------------------------------------------------------------------------


#Look at the full commit.
--------------------------------------------------------------------------------------------
git log
git reflog
git log --reflog
#Notice also our head pointer is pointing to main which is just a reference to a commit hash


#Lets prove a point about it only storing unique content
-------------------------------------------------------------------------------------------
Copy-Item .\textfile.txt .\textfile2.txt
git add .
#what new object do we have? Nothing.
git status
git commit -m "textfile2.txt added"
#We have new files. Look again


#Modify a file and stage
-------------------------------------------------------------------------------------------
code .\textfile.txt
git add textfile.txt
git status


#add a 3rd file 
code .\textfile3.txt
git add textfile3.txt
git status

git commit -m "Edited text file, add 3rd file"

gitgraph


#We can look at the changes
-------------------------------------------------------------------------------------------
git log -p #also shows the diff/patch between the commits :q

gitgraph
git diff <commit>..<commit> #diff between specific commits
#Remember the complete snapshot is stored. All diffs are generated at time of command execution
-------------------------------------------------------------------------------------------


#Removing content 
-------------------------------------------------------------------------------------------
code testfile4.txt
git add testfile4.txt
git commit -m "adding testfile4.txt"
git status
git rm testfile4.txt
git status #Note the delete is staged
ls #its gone from stage AND my working
git commit -m "removed testfile4.txt"


#Reset file to original after modifications have been done do it.
-------------------------------------------------------------------------------------------
code textfile.txt
git status
git restore textfile.txt
git status


#Resetting Folder after git add. Removing all staged content. (Edited file or files, but did not wanted to do that)
------------------------------------------------------------------------------------------------------------------
code textfile.txt
git add .
git status #file is now staged
git reset  #It does NOT change your working dir
git status #file not staged anymore for commit, BUT CHANGE IS STILL THERE

#git reset --hard would also change your working directory to match!
code textfile.txt
git add .
git reset --hard 
-------------------------------------------------------------------------------------------


#Reset individual files after git add . (Edited file but did not wanted to do that)
-------------------------------------------------------------------------------------------
code textfile.txt
git add textfile.txt
git status
#Restore version in staged (from last commit HEAD) but NOT working
git restore --staged textfile.txt
git status
#Restore working from stage
#Status here is before git add . is done. 
#any modifications before add can be cancelled with this comand.
git restore textfile.txt
git status
-------------------------------------------------------------------------------------------


#Undo a commit
-------------------------------------------------------------------------------------------
git reset HEAD~1 --hard #all in one go

#list all previous versions, also the ones tha in "future".
git log --reflog

#Could also reset by a specific commit ID
git reset <first x characters of commit> --soft
git reset 3e5c944 --hard #all in one go  

#Step by step explained bellow:
#Remember, a branch is just a pointer to a commit which points to its parent. #We can just move the pointer backwards!
#Move back 1 but do not change staging or working. Could go back 2, 3 etc ~2, ~3
git reset HEAD~1 --soft
gitgraph
#Notice we have moved back but did not change staging or working
git status
#So staging still has the change that was part of the last commit that is no longer referenced

#to also reset staging. Note as I'm not specifying a commit its resetting working to the current commit which i've rolled back already
#--mixed is actually the default, i.e. same as git reset which we did before to reset staging!
git reset --mixed
git status

#Now to also reset working. Again since no commit specified its just setting to match current commit. This should look familiar!
#--hard changes staging and working
git reset --hard
git status
#Now clean

git reset HEAD~1 --hard #all in one go, 1 step backgit
-------------------------------------------------------------------------------------------



#TAGS
--------------------------------------------------------------------------------------------
git tag v1.0.0
gitgraph
git tag v0.5.1 09f24f4
gitgraph
git tag --list

#lets look at a commit that is tagged. Show gives information about an object. For a commit the log message and diff
git show v1.0.0
#We just see the commit object

#Note tags have to be pushed to a remote origin for them to be visible there. We will cover later
git push --tag
--------------------------------------------------------------------------------------------


#Remote Origins (Push, Pull = Fetch + Merge) explained
--------------------------------------------------------------------------------------------
git remote add origin https://github.com/raine2703/gitplay2.git
git remote remove origin

git remote -v
gitgraph

#Push to the remote referened as origin
git push -u origin main
#Look at it on github. All there. Except tags
git push --tag
#Much better

gitgraph
#Now has origin/main pointer known

#Make a change directly on the github repo!
gitgraph
git status
#We don't know about it

#Pull down remote changes
git pull
#Can specify where to pull from and branch
git pull origin main
#Pull from all remotes
git pull --all
#It pulled down the changes and MERGED with a fast-forward. Remember that
git status
gitgraph

#git pull actually is doing two things
#To just get remote content, this shows if there has been a change remotely
git fetch
#Content is now on our box, just not "merged"
gitgraph
git status
#we can see its just ahead as a direct child of our commit so a straight line to it
git merge
#fast forward again
gitgraph
-------------------------------------------------------------------------------------------


#Example: Pull, make a change locally, then push!
-------------------------------------------------------------------------------------------
#As a best practice pull first (fetch and merge) to ensure all clean
git pull
code textfile.txt
git add .
git commit -am "Updated testfile.txt x3"
git status
gitgraph
git push
#git push --tags
-------------------------------------------------------------------------------------------


#Branches and merging them togeather! 
-------------------------------------------------------------------------------------------

#Fast Forward - edit branch, then merge from main.
#3 way merge - edit branch, edit main, then merge from main. Have to fix errors and commit again.
#Rebase. Edit main, edit branch. Rebase branch with main so its easier to merge later from main.

#summary:
git branch branch1
git branch --list #* shows where you are
git switch branch1
git add .
git commit -m "Main edit"
git switch main
git merge branch1 # this is fast forward.
gitgraph
git branch -d branch1 #no longer needed


#You may not want fast-forward. Maybe in the history you want to see it was a separate branch that got merged in
git merge --no-ff branch1 # will show that there was branch

# Rebase - merge branch with main so later on its easier to merge main with branch.
# Firstly Edit main, THen Edit Branch, Then Rebase branch from main, then merge main with branch.
git add .
git commit -m "Edit branch"
git switch branch1
git status
git rebase main
git add .
git rebase --continue
gitgraph
git switch main
git merge branch1


#Detailed example below:
-------------------------------------------------------------------------------------------
cd ..
mkdir repo2
cd repo2
git init
git status
#we see main which remember just references a commit (that won't exist yet)

code textfile.txt
git add textfile.txt
git commit -m "Initial commit"
gitgraph

#View all branches. * is current
git branch --list
#View remotes
git branch -r
#View all (local and remote)
git branch -a

#Create a new branch pointing to where we are called branch1
git branch branch1
gitgraph
#Notice point to same commit at this time

git branch --list
git checkout branch1
#or better move to new switch that is based around movement to separate commands
#switch only allows a branch to be specified. Checkout allows a commit hash (so could checkout a detached head)
git switch branch1
git branch --list
gitgraph
#When we switch it also updates the staging and working directory for the checked out branch

#To create and checkout in one step:
git checkout -c branch1

#Check which branch we are on
git branch

#Make a change to jl.csv adding some text. ON BRANCH ONE
code .\textfile.txt
git add .
git commit -m "Added Second line"
gitgraph
#Notice the branch is now ahead of main
#Make another change
code .\textfile.txt
git add .
git commit -m "Added third line"
gitgraph
#all clean

#switch between branches and check results
git switch main
type .\textfile.txt
git status
git switch branch1
type .\textfile.txt
git status
#Notice as I switch it does that update of not only the branch but gets the stage and working to same state

gitgraph
#the branch1 is now 2 ahead but its a straight line from the main

#Merge Branches
-------------------------------------------------------------------------------------------
git status
#Move to main
git switch main
#we can look at the differences
git diff main..branch1
#If happy lets merge them. Remember we already switched to main. We are going to merge into this from branch1
git merge branch1
#Done. Notice was a fast-forward. Lets look at merged branches
git branch --merged

gitgraph

#Delete Branches
-------------------------------------------------------------------------------------------
#This would only delete locally
#Remember to ALWAYS check it has been merged first before deleting
git branch --merged
git branch -d branch1
#To delete on a remote
git push origin --delete branch1
-------------------------------------------------------------------------------------------


#To push a branch to a remote
-------------------------------------------------------------------------------------------
git push -u <remote repo, e.g. origin> <branch name>








