BEGIN {
  jsonout = 0
  htmlout = 1

  if (jsonout) print "["
  if (htmlout) print "<p style=\"text-align:center; font-family: Palatino, serif\">(multiply bills by 1000)</p>"
  tmp = "lynx -source 'https://www.opensecrets.org/personal-finances/top-net-worth'"
  
  if (htmlout) print "<h1 style=\"text-align:center; text-align:center; font-family: Palatino, serif;\">Median American</h1></br>"
  if (htmlout) visualize(97300)
  if (htmlout) printf "</br></br></br></br>"

  while (tmp | getline) {
    # if it's not a <td> tag followed by a link, skip it
    if ($0 !~ /<td><a href=/) continue
    
    if (jsonout) printf "{\n"
    gsub(/<a .*href[^>]*>/,"") #remove starting a tag
    gsub(/<\/a>/,"") #remove ending a tag
    gsub(/<td>/,"") #remove starting td tag
    gsub(/<\/td>/,"") #remove ending td tag

    #delete leading and trailing spaces
    gsub(/^[ \t]+|[ \t]+$/,"")
    gsub(/ \(.*\)$/,"")
    
    name = $0
    if (jsonout) printf "\t\"name\": \"" name "\",\n";
    if (htmlout) print "<h1 style=\"text-align:center; text-align:center; font-family: Palatino, serif\">" name "</h1></br>" 
    
    # skips highest est and goes to average 
    tmp | getline waste;
    tmp | getline;

    # get avg net worth
    gsub(/<td class="number">/,"")
    gsub(/<\/td>/,"")
    gsub(/,/,"")
    gsub(/^[ \t]+|[ \t]+$/, "")
    gsub(/\$/,"")
    avg = $0
    if (jsonout) printf "\t\"average\": \"" avg "\",\n";
    #if (htmlout) print "<li>" avg "</li>" 
    if (htmlout) visualize(avg)
    printf "</br></br></br></br>"

    # skips lowest est and goes to branch name
    tmp | getline waste;
    tmp | getline

    # removes td tags
    sub(/<td>/,"")
    sub(/<\/td>/,"")
    #delete leading and trailing spaces
    gsub(/^[ \t]+|[ \t]+$/,"")

    branch = $0
    if (jsonout) printf "\t\"branch\": \"" branch "\"\n"
    #if (htmlout) print "<li>" branch "</li>"    

    if (jsonout) printf "}\n"
    
  }
  if (jsonout) print "]"
  close(cmd)
}

func visualize(num) {
  fivethou = (num - (num % 5000000)) / 5000000;
  num = num % 5000000;
  onethou = (num - (num % 1000000)) / 1000000;
  num = num % 1000000;
  fivehund = (num - (num % 500000)) / 500000;
  num = num % 500000;
  onehund = (num - (num % 100000)) / 100000;
  num = num % 100000;
  fifty = (num - (num % 50000)) / 50000;
  num = num % 50000;
  ten = (num - (num % 10000)) / 10000;
  num = num % 10000;
  five = (num - (num % 5000)) / 5000;
  num = num % 1000;
  one = (num - (num % 1000)) / 1000;
  
  for (i = 0; i < fivethou; i++) {
    printf "<img src=\"monopolypics/5000.jpg\" alt=\"5000\" width=\"55\" style=\"padding: 2px;\">"
  }
  for (i = 0; i < onethou; i++) {
    printf "<img src=\"monopolypics/1000.jpg\" alt=\"1000\" width=\"55\" style=\"padding: 2px;\">"
  }
  for (i = 0; i < fivehund; i++) {
    printf "<img src=\"monopolypics/500.jpg\" alt=\"500\" width=\"55\" style=\"padding: 2px;\">"
  }
  for (i = 0; i < onehund; i++) {
    printf "<img src=\"monopolypics/100.jpg\" alt=\"100\" width=\"55\" style=\"padding: 2px;\">"
  }
  for (i = 0; i < fifty; i++) {
    printf "<img src=\"monopolypics/50.jpg\" alt=\"50\" width=\"55\" style=\"padding: 2px;\">"
  }
  for (i = 0; i < ten; i++) {
    printf "<img src=\"monopolypics/10.jpg\" alt=\"10\" width=\"55\" style=\"padding: 2px;\">"
  }
  for (i = 0; i < five; i++) {
    printf "<img src=\"monopolypics/5.jpg\" alt=\"5\" width=\"55\" style=\"padding: 2px;\">"
  }
  for (i = 0; i < one; i++) {
    printf "<img src=\"monopolypics/1.jpg\" alt=\"1\" width=\"55\" style=\"padding: 2px;\">"
  }
}
