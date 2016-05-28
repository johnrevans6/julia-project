using DataFrames

function calculate_scores(df)

   #Group dataframe by author
   groups = groupby(df,:author);

   #Create temporary dataframe for passion_scores
   scores = DataFrame(author="",subreddit="",passion_score=0.0);

   #Loop through the grouped authors
   for i=1:length(groups);
      #split a given author into separate df
      slice = groups[i];
      #print(slice)
      #add the total records for the author
      sum_posts = nrow(slice);
      #print(sum_posts)

      #Count up the number of times the author posts to a subreddit
      subreddit_sums = by(slice,[:author,:subreddit],nrow);
      #print(subreddit_sums)

      #Divide the total posts for each subreddit by the total number
      #of posts.
      #TODO: Apply weighted windowing function
      score = subreddit_sums[:x1]/sum_posts;
      #print(passion_score)

      #Apply scores back to each subreddit for the author
      subreddit_sums[:x1] = score;
      rename!(subreddit_sums,:x1,:passion_score)

      #append the author set to the scores df
      append!(scores,subreddit_sums)
   end
   #delete first row since it's empty
   deleterows!(scores,1)

   return scores

end

function fill_missing(df)
  #group the datafram into authors
  groups = groupby(df,:author)
  #find the unique subreddits in the dataframe
  sr = unique(df[:subreddit])

  all_subs = DataFrame(author="",subreddit="",passion_score=0.0);

  for i=1:length(groups)
    #copy the subreddits so I don't need to call unique on each iteration
    cpy = sr

    #grab a slice containing a given author
    slice = groups[i];

    #find the indexes of subreddits already observed by the other.
    #These have already been scored and should not be appended
    idx = findin(slice[:subreddit],cpy)

    #convert the copy into a df and delete the subreddits already observed
    #result is a dif
    dif = DataFrame(subreddit=cpy)
    deleterows!(dif,idx)

    #convert the dif into an array of ASCIIStrings
    #TODO: this hacky, find a better way
    hack = ASCIIString[string(x) for x in dif[:subreddit]]

    #create ASCIIString array that pads the author column
    auth = fill!(Array(ASCIIString,nrow(dif)),slice[:author][1])

    #create a temporary df and assign author, subreddit and scores
    tmp = DataFrame(author=auth,subreddit=hack,passion_score=0.0)

    #append the original slice
    append!(all_subs,slice)

    #append the missing values
    append!(all_subs,tmp)
  end

  #delete the first row since it's blank and return the full df
  deleterows!(all_subs,1)
  return all_subs
end
