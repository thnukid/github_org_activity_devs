# GithubOrgActivityDevs

Find out which repositories are watched by team members of an organization

Needs a `github oauth token` and a `team_member_id` of the github team

## Example Output

```
$ bundle exec bin/github_org_activity_devs
# waiting longtime...

thnukid

CreateEvent
thnukid - created - branch - master - https://github.com/thnukid/phily-oss.netlify.com - 1 Week, 2 Days, 19 Hours, 41 Minutes and 53 Seconds
thnukid - created - repository - https://github.com/thnukid/phily-oss.netlify.com - 1 Week, 2 Days, 19 Hours, 43 Minutes and 50 Seconds

PushEvent
thnukid - 1 commits - refs/heads/master - https://github.com/thnukid/phily-oss.netlify.com - 1 Day, 15 Hours, 52 Minutes and 35 Seconds
```

## Features

:white_check_mark: Fetches team member login names

:white_check_mark: Fetch public user events for team members

:white_check_mark: Fetch description and language of repository

:white_check_mark: use ActiveSupport File Store Cache

## Installation

1. Clone this repository

```
    $ git clone git@github.com:thnukid/github_org_activity_devs.git
```

2. Install

```
    $ cd github_org_activity_devs/
```

```
    $ bundle
```

## Usage

1. Copy `.env.example` to `.env`

```
    $ cp .env.example .env
```

2. Edit `.env`

```
    $ vim .env
```

3. [Get a github auth token](https://github.com/settings/tokens)
4. Get the team member id
5. Make executable

```
    $ chmod +x bin/github_org_activity_devs
```

6. Run the summary

```
    $ bundle exec bin/github_org_activity_devs
```

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
