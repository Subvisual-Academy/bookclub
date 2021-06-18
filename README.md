# Bookclub

A Rails web app which serves as a repository for Subvisual's monthly book club gathering. In each session each participant talks about one or more books they have been reading. Ocasionally, there's, at the end, a special section where either one person presents a list of recommendations or there's a thematic book presentation (ex: childhood books).

This project was developed in the scope of the 2020 Subvisual Summer Camp internship.

## Prequisites

To run this project you will need the following tools and runtimes:

- Ruby 2.7.2
- Node 14.15.3
- Postgres 10+
- Chromedriver

Here at our team, we use [asdf-vm](https://github.com/asdf-vm/asdf) to manage our Ruby and Node versions, we recommend that heavily. 

Our `bin/setup` script will handle installing Ruby and Node if you have [asdf-vm](https://github.com/asdf-vm/asdf) properly installed, as well as checking if all the other necessary tools are present in the system.

## Testing

Run `bundle exec rspec` for tests. We are testing heavily, from simple (but not crazy) unit tests to full integration tests.

# Developing

Just run `bin/server` to start hammering away at it. Access the server at `localhost:5000`

The .env variables deal with connecting to a webhook for the bookclub channel in Subvisual's Slack space.