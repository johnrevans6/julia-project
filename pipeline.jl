include("JSONParser.jl")
include("preprocess.jl")
include("recommendations.jl")

df = parse_json("D:\\datasets\\reddit\\RC_2012-01.json");

#Drop rows without an author
df = df[df[:author] .!= "[deleted]",:];

#Count total posts for each author
post_counts = by(df,:author,nrow);
#Find authors who have posted more than n times
post_counts = post_counts[post_counts[:x1] .> 75,:]

#Extract authors
authors = findin(df[:author],post_counts[:author])

#Take subset from master df
subset = df[authors,:];

#Calculate passion scores
passion_scores = calculate_scores(subset);

complete_df = fill_missing(passion_scores);


###Scratch space ###

function getrecommendations(df,user_list,user)

  #This vector will come in handy later
  rows = collect(1:nrow(df))

  #Extract user from dataframe
  user_df1 = df[df[:author].== user,:]
  #print(user_df1)



  #TODO: Find similar items between users
  for other in length(df)

    user_df2 = df[df[:author].== user_list[1],:]
  end
  #print(user_df2)
  #TODO: cor(user_df1[:passion_score],user_df2[:passion_score])
  #sim = cor(user_df1[findin(user_df1[:subreddit],user_df2[:subreddit]),:passion_score],
  #  user_df2[findin(user_df2[:subreddit],user_df1[:subreddit]),:passion_score])



  print(sim)
  #TODO: The hard part. Minimize the error between similar users
  #Rank these scores
  #Sort
  #Add to recommendations dataframe



end
