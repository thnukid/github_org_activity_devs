# GithubOrgActivityDevs

Find out which repositories are watched by team members of an organization

Needs a `github oauth token` and a `team_member_id` of the github team

## Example Output

```
$ bundle exec bin/github_org_activity_devs
# waiting longtime...
+---------------+------------+----------------+
| github_login  |            |                |
|               |            |                |
|               | gitevent   |                |
|               |            | repo/repo-name |
|               |            | repo desc      |
|               |            | repo language  |
|               |            | ~              |
|               |            | repo/repo-name |
|               |            | repo desc      |
|               |            | repo language  |
|               |            | ~              |
|               | gitevent   |                |
|               |            | repo/repo-name |
|               |            | repo desc      |
|               |            | repo language  |
|               |            | ~              |
|               | -          |                |
+---------------+------------+----------------+
...
```

## Features

[x] Fetches team member login names
[x] Fetch public user events for team members
[x] Fetch description and language of repository
[x] use ActiveSupport File Store Cache
[x] prints a Terminal Table in the console output

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

3. Get a github auth token
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
