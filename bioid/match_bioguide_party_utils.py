'''
Utils file containing functions for main_cs.py


'''

import requests
import pandas as pd

def load_propublica_congress_api(key,session_start = 102, session_end = 115):
    """
    Load in Propublica Congress Data

    https://projects.propublica.org/api-docs/congress-api/

    INPUT:
        key - API Auth Key
        session_start - first session to query from
        session_end - last session to query from
        NOTE: the range queried will be [session_start TO session_end]
    OUTPUT:
        entry_list - JSON structure of results with added entry ['congress'] to denote session
    """
    # currently avaliable sessions (102-115)

    session_vals = range(102,116)

    headers = {
    "X-API-Key":key }

    df_list = []

    for session_val in session_vals:
        url = "https://api.propublica.org/congress/v1/{}/house/members.json".format(session_val)
        r = requests.get(url,headers = headers)

        df_list.append(r.json()['results'][0])


    """
    Since the structure is nested, we want only congress session + party

    """
    entry_list = []
    for entry in df_list:
        entry_members_copy = entry["members"].copy()

        for x in entry_members_copy:
            x["congress"] = entry["congress"]
            entry_list.append(x)

    return entry_list

def measure_dropped_records(og,new):
    """
    Summary function to compare sizes of dataframes

    INPUT:
        og : original dataframe
        new: new dataframe
    OUTPUT:
        print statements summarizing sizes
    """

    print("New DF {}".format(new.shape))
    print("Old DF {}".format(og.shape))
    print("Comparison Size {:.2f}%".format(len(new)/len(og)*100))

def generate_bioid_party_lookup(df_house,r_mem):
    """
    Match BioID with Party

    INPUT:
        df_house - house_expenditure data
        r_mem - JSON member request from def load_propublica_congress_api

    OUTPUT:
        df_bioid_party_lookup - dataframe with 1-1 mapping of Bioguide ID to Party, Session
        df_bioid_party - original df_house with added column of Party + Congress

    """
    # slice data frame to only look at entries WITH bioguide id
    df_bioid = df_house[df_house["bioguide_id"].notnull()]

    # summary stats of dropped records
    # measure_dropped_records(df_house,df_bioid)

    s_bioid_unique = df_bioid["bioguide_id"].unique()

    dict_id_party = {}
    for entry in r_mem:
        if entry['id'].lower() in s_bioid_unique:
            dict_id_party[entry['id'].lower()] = [entry['party'],entry['congress']]

    df_bioid_party_lookup = pd.DataFrame.from_dict(dict_id_party,orient = 'index').reset_index()
    df_bioid_party_lookup.columns = ["bioguide_id","party","congress"]

    df_bioid_party = pd.merge(df_bioid,df_bioid_party_lookup,how = 'left')

    return df_bioid_party_lookup,df_bioid_party


