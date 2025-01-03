
# E. Culurciello
# soccer data with API from https://www.football-data.org
# api reference: https://docs.football-data.org/general/v4/index.html

import requests
# import json
from datetime import datetime


print("last games real madrid:")
uri = 'https://api.football-data.org/v4/teams/86/matches?status=FINISHED&limit=10'
headers = { 'X-Auth-Token': 'YOUR-API-KEY' }

response = requests.get(uri, headers=headers)
for match_data in response.json()['matches']:
#   print(match)
    home_team = match_data['homeTeam']['name']
    away_team = match_data['awayTeam']['name']
    home_score = match_data['score']['fullTime']['home']
    away_score = match_data['score']['fullTime']['away']
    winner = match_data['score']['winner']
    utc_date_str = match_data['utcDate']  # Get the UTC date

    # Convert UTC date string to a more readable format
    utc_date = datetime.fromisoformat(utc_date_str.replace('Z', '+00:00'))
    formatted_date = utc_date.strftime("%Y-%m-%d %H:%M:%S UTC")

    print(f"Match Result: {formatted_date} - {home_team} {home_score} - {away_score} {away_team}")



print("la liga standings:")
uri = 'https://api.football-data.org/v4/competitions/PD/standings'
headers = { 'X-Auth-Token': 'a0cf963ad1ef47b78e0380c78021204a' }

response = requests.get(uri, headers=headers)
for team_data in response.json()['standings'][0]['table']:
    team_name = team_data['team']['name']
    position = team_data['position']
    points = team_data['points']
    print(f"Position: {position} - {team_name} - Points: {points}")

    
