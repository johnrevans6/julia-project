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
