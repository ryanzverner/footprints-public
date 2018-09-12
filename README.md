# Footprints

This program is an applicant tracking tool that allows users to manage the employee hiring process from start to finish.

To run this program, first copy the repository url from github, then run
`git clone [url]` in your terminal to make a local copy of the repo.

This program uses ruby version 2.1.5.
`ruby -v` will display what version of ruby you are running.
	If you are not running the correct ruby version, run
	`rbenv install 2.1.5` to install it using homebrew, then enter
	`rbenv local 2.1.5` to switch to this ruby version.

Next, enter
`bundle install` to install all gems used in this program.
	If you do not have bundler installed, enter
	`brew install bundler` first.

Enter
`rake db:migrate` and `rake db:seed` to populate
the database with default values.

Enter
`rails server` to start the program locally.

Enter
`localhost:3000` as a url in your web browser of choice to view the program.

#### Note

Footprints requires anybody who logs in to also be a crafter. You will have to manually add a person to the system as a crafter in order to log into Footprints.
