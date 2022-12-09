

#John Savill DevOps Master Class - Master Git
--------------------------------------------------------------------------------------------
#Check version
git --version
--------------------------------------------------------------------------------------------
#Turn any folder into a repo which creates a sub .git folder
git init
--------------------------------------------------------------------------------------------
#Set initial git configuration
#Can replace --global with --local to set values for a specific repo if required
git config --global --list    #care about username and email

git config --global user.name "raine2703"
git config --global user.email raine2703@gmial.com

git config --list --show-origin      #see where coming from :q
git config --list

#Many other settings https://git-scm.com/book/en/v2/Getting-Started-First-Time-Git-Setup
git config --global init.defaultBranch main #this is very common to use instead of master
-------------------------------------------------------------------------------------------
#push to existing github, first have to add remote origin, then pull/push.
git remote add origin https://github.com/raine2703/test3

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
function gitgraph {git log --oneline --graph --decorate --all}
-------------------------------------------------------------------------------------------


#Pay attention to the current .git folder content, especially the objects folder
git add .
#Notice we now have a new object in a 2 character folder name with 38 character name, i.e. 40 character hash
git status
git diff --cached #Difference between staged and what is commited
git commit -m "Initial testfile.txt commit"
#We have two new objects created! The path and the commit itself

#NOTE Could combine the add and commit
git commit -am "Initial testfile.txt commit"
#or even
git commit -a -m "Initial testfile.txt commit"

#Look at the full commit.
git log
#Notice also our head pointer is pointing to main which is just a reference to a commit hash

#look at the type
git cat-file -t <first 7 of the hash shown for the commit>
#look at the content
git cat-file -p <first 7 of the hash shown for the commit>

#look at the type
git cat-file -t <first 5 (to show just needs to be unique) of the hash shown for the tree in commit file>
#look at the content. Notice here it points the blob we saw created before and now has a file name
git cat-file -p <first 5 of the hash shown for the tree in commit file>

#look at the type
git cat-file -t <first n of the hash shown for the blob in tree file>
#look at the content. Notice here it points the blob we saw created before and now has a file name
git cat-file -p <first 5 of the hash shown for the blob in tree file>

#Lets prove a point about it only storing unique content
Copy-Item .\testfile.txt .\testfile2.txt
git add .
#what new object do we have? Nothing.
git status
git commit -m "testfile2.txt added"
#We have new files. Look again

git log --oneline --graph --decorate --all   #I will be using this a lot
git cat-file -p <new commit>  #Note it references the parent commit hash, again, can't change history as hash would not match
git cat-file -p <new tree pointed from new commit>
#WOW, two file names. SAME BLOB as had same content
#Our main reference also now points to the new commit, it just moved along

#Note when you create a new repo you can override the default initial branch
git init --initial-branch=main
git init -b main

#WB06
#Modify a file and stage
code .\testfile.txt
git add testfile.txt
git status
#add a 3rd file but don't stage
code .\testfile3.txt
git status

git commit -m "updated testfile"
git status
#notice our untracked file, i.e. working is not changed but staging is now matching the repo

gitgraph

#We can look at the changes
git log -p #also shows the diff/patch between the commits :q

gitgraph
git diff <commit>..<commit> #diff between specific commits
#Remember the complete snapshot is stored. All diffs are generated at time of command execution

#WB07
git status
git add testfile3.txt
code testfile.txt #make a change
git status
#Between what is staged and the HEAD commit (i.e. the REPO). Could also use --staged which is synonym of --cached
git diff --cached
#And what is working to staged
git diff
#Between working and the last commit (i.e. head)
git diff HEAD #basically the sum of the above two


#To remove content WB08
#stage the removal (which will also delete from working)
git rm <file>
#to ONLY stage the remove (but not delete from working)
git rm --cached <file>
#Could also just delete from working then "add" all changes
git add .

#Then you need to commit as normal
git commit -m "Removed file x"

#Example
code testfile4.txt
git add testfile4.txt
git commit -m "adding testfile4.txt"
git status
git rm testfile4.txt
git status #Note the delete is staged
ls #its gone from stage AND my working
git commit -m "removed testfile4.txt"


#Resetting WB09
#Remove all staged content. After gitt add . is done.
#It does this by setting staged to match the last commit
#It does NOT change your working dir
git reset

#Would also change your working directory to match!
git reset --hard 

#Can reset individual files
code testfile.txt
git add testfile.txt
git status
#Restore version in staged (from last commit HEAD) but NOT working
git restore --staged testfile.txt
git status
#Restore working from stage
#Status here is before git add . is done. 
#any modifications before add can be cancelled with this comand.
git restore testfile.txt
git status
code testfile.txt
#Restore to stage and working from last commit. Reset to original with one comand. After add . is done.
git restore --staged --worktree testfile.txt


#WB10
#What if we want to undo a commit?
#to view all
git log
gitgraph

#Remember, a branch is just a pointer to a commit which points to its parent
#We can just move the pointer backwards!
#Move back 1 but do not change staging or working. Could go back 2, 3 etc ~2, ~3
git reset HEAD~1 --soft
gitgraph
#Notice we have moved back but did not change staging or working
git status
#So staging still has the change that was part of the last commit that is no longer referenced

#Could also reset by a specific commit ID
git reset <first x characters of commit> --soft

#to also reset staging. Note as I'm not specifying a commit its resetting working to the current commit which i've rolled back already
#--mixed is actually the default, i.e. same as git reset which we did before to reset staging!
git reset --mixed
git status

#Now to also reset working. Again since no commit specified its just setting to match current commit. This should look familiar!
#--hard changes staging and working
git reset --hard
git status
#Now clean

#Could do all in one go
gitgraph
git reset HEAD~1 --hard
gitgraph
git status
#all clean since --hard reset all levels back

#The now unreferenced commit will eventually be garbage collected

#TAGS WB11
gitgraph
#remember commits just form a chain as they point to their parent.
#Notice I'm using HEAD which just points to a reference which points to a commit!
git cat-file -t HEAD
git cat-file -p HEAD

#I can create a tag at the current location
git tag v1.0.0
gitgraph
git tag v0.5.1 46d8095
gitgraph
git tag --list

#lets look at a commit that is tagged. Show gives information about an object. For a commit the log message and diff
git show v1.0.0
#We just see the commit object

#These are lightweight tags. There is also an annotated type which is a full object with its own message
git tag -a v0.0.1 46d8095 -m "First version"
git show v0.0.1
#we see the TAG information AND then the commit it references
git cat-file -t v0.0.1
git cat-file -t v1.0.0

#Note tags have to be pushed to a remote origin for them to be visible there. We will cover later
git push --tag


#Create an empty repo on GitHub under your account called gitplay1
#It has help about next steps

#Add it as the remote origin. Origin is just a name but common standard
git remote add origin https://github.com/raine2703/gitplay.git
git remote remove origin
#git branch -M main      # RENAMES the branch from master to main

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

git cat-file -p origin/main
#Content is now on our box, just not "merged"
gitgraph
git status
#we can see its just ahead as a direct child of our commit so a straight line to it
git merge
#fast forward again
gitgraph


#WB14
#Likewise if we change locally we need to push to the remote
#As a best practice pull first (fetch and merge) to ensure all clean
git pull
#make a change
code testfile.txt
git commit -am "Updated testfile.txt"
git status
gitgraph
git push
#git push --tags


#Branches!
#Start fresh
cd ..
mkdir repo2
cd repo2
git init
git status
#we see main which remember just references a commit (that won't exist yet)

code jl.csv
git add jl.csv
git commit -m "Initial JL roster CSV"
#WB-15black (down)

#View all branches. * is current
git branch --list
#View remotes
git branch -r
#View all (local and remote)
git branch -a

#WB15-orange
#Create a new branch pointing to where we are called branch1
git branch branch1
gitgraph
#Notice point to same commit at this time

#WB15-red
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

#To push a branch to a remote.
#The -u sets up tracking between local and remote branch. Allows argumentless git pull in future. Will do this later
git push -u <remote repo, e.g. origin> <branch name>

#Check which branch we are on
git branch

#WB16
#Make a change to jl.csv adding Diana
code jl.csv
git add -p
#Yep the above shows the actual changed chunks and can select parts! Now commit
git commit -m "Added Wonder Woman"
gitgraph
#Notice the branch is now ahead of main
#Make another change adding Barry
code jl.csv
git add .
git commit -m "Added The Flash"
gitgraph
git status
#all clean

git switch main
type jl.csv
git status
git switch branch1
type jl.csv
git status
#Notice as I switch it does that update of not only the branch but gets the stage and working to same state

gitgraph
#the branch1 is now 2 ahead but its a straight line from the main

#WB16b
#Now we want to merge the changes into main
#Make sure everything clean
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

#We no longer need branch1. Remember use tags if you want some long lived reference
#This would only delete locally
#Remember to ALWAYS check it has been merged first before deleting
git branch --merged
git branch -d branch1
#To delete on a remote
git push origin --delete branch1


#You may not want fast-forward. Maybe in the history you want to see it was a separate branch that got merged in
#I am now going to mess around with time. Remember a branch is nothing more than a pointer to a commit
#I can go backwards. In this case I'm going to move main BACK to before I made the last two changes
gitgraph
#Remember --hard also updates staging and working
git reset --hard HEAD~2
gitgraph
#The other two commits are still out there but nothing references them. They will eventually get cleaned up
#We can look and still see via the reference logs
git reflog

#Lets do it all again
#WB17
git branch branch1
git switch branch1
code jl.csv
git add .
git commit -m "Added Test4"
code jl.csv
git add .
git commit -m "Added Test5"
gitgraph
git status
#looks familiar and all clean

#This time specify NOT to perform a fast forward
git switch main
git diff main..branch1
git merge --no-ff branch1
git branch --merged

gitgraph
#Notice the merge was a new commit

#We can still delete branch1 as its still merged
git branch --merged
git branch -d branch1
#History is kept there was a branch
gitgraph


#WB18
#Lets make it more complicated
#Rewind time again (only doing this so our view is simpler)
#Note using ^ instead of ~. This is because NOW main has two parents.
#I'm saying go back to the first parent instead of ~ for number of generations
git reset --hard HEAD^1
gitgraph

#Make the branch1 again with two commits
git branch branch1
git switch branch1
code jl.csv
git add .
git commit -m "Added Wonder Woman"
code jl.csv
git add .
git commit -m "Added The Flash"
gitgraph
git status

#Switch to main
git switch main
code jl.csv
git add .
git commit -m "Added Cyborg"

gitgraph
#More interesting. There is now NOT a direct path from branch1 to main
git status
#We will have conflicts given the changes we made
git merge branch1
#We need to fix them by editing the file it tells us and conflicts have been marked
code jl.csv
#We are in conflict status:
git status
git add .
git commit -m "Merged with branch1"

gitgraph
#Shows the 3-way merge is complete
#Take a little screen shot of this and paste next to 3-way merge picture!

git branch --merged
#Could delete the branch now BUT I DON'T WANT TO
#git branch -d branch1
gitgraph


#There is another option. Rebase??? Logic not clear.
