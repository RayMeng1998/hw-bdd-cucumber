# Add a declarative step here for populating the DB with movies.

Given /the following movies exist/ do |movies_table|
  movies_table.hashes.each do |movie|
    # each returned element will be a hash whose key is the table header.
    # you should arrange to add that movie to the database here.
    Movie.create!(movie)
  end
end

Then /(.*) seed movies should exist/ do | n_seeds |
  Movie.count.should be n_seeds.to_i
end

# Make sure that one string (regexp) occurs before or after another one
#   on the same page

Then /I should see "(.*)" before "(.*)"/ do |e1, e2|
  #  ensure that that e1 occurs before e2.
  #  page.body is the entire content of the page as a string.
  a = page.body.index(e1)
  b = page.body.index(e2)
end

# Make it easier to express checking or unchecking several boxes at once
#  "When I uncheck the following ratings: PG, G, R"
#  "When I check the following ratings: G"

When /I (un)?check the following ratings: (.*)/ do |uncheck, rating_list|
  # HINT: use String#split to split up the rating_list, then
  #   iterate over the ratings and reuse the "When I check..." or
  #   "When I uncheck..." steps in lines 89-95 of web_steps.rb
  rating_list.split(/\s*,\s*/).each do |rating|
    if uncheck.nil?
      step %Q{I check "ratings_#{rating}"}
    else
      step %Q{I uncheck "ratings_#{rating}"}
    end
  end
end

Then /I should (not )?see movies with the following ratings: (.*)/ do |neg, rating_list|
  if neg.nil?
    ratings = rating_list.split(",")
    ratings.each do |rating|
      rating.strip!
      steps %Q{Then I should see /^#{rating}$/}
    end
  elsif neg
    ratings = rating_list.split(",")
    ratings.each do |rating|
      rating.strip!
      steps %Q{Then I should not see /^#{rating}$/}
    end
  end
end

Then /I should see all the movies/ do
  # Make sure that all the movies in the app are visible in the table
  page.all("#movies tbody td:nth-child(1)").map { |movie| movie.text }.count.should == Movie.count
end

When /I press Refresh/ do
  click_button("Refresh")
end
