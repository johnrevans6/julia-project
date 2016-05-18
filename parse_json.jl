using JSON
using DataFrames

#Inputs: absolute path to json file
#Outputs: Dataframe comprised of 4 attributes
function parse_json(fn)
  f = open(fn,"r")

  #Read in the first 5000 datapoints. This can be increased to about 100000
  #before performance becomes a factor
  chunk_size = 10000
  chunk_length = 2
  data_set = []

  for i=1:chunk_size
    chunk = join([readline(f) for j=1:chunk_length])
    push!(data_set,JSON.parse(chunk))
  end
  close(f)

  #convert to DataFrame
  data_set=data_set
  len = length(data_set)
  df = DataFrame(subreddit_id="",subreddit="",author="",created_utc="")


  for i in 1:len
    push!(df,[data_set[i]["subreddit_id"],data_set[i]["subreddit"],
      data_set[i]["author"],data_set[i]["created_utc"]])
  end

  #delete first row since it's just empty strings
  deleterows!(df,1)

  return df
end

###Sample usage###
#df = parse_json("D:\\datasets\\reddit\\RC_2012-01.json")
#print(df[10000,:])
