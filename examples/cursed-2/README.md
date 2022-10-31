Cursed Containers 2: Blue Team's Clues and the Containers of Secrets

# The Setup 
Last year at Halloween, an evil pirate captain (Pieter) cursed our containers, causing them to break and need to be debugged. Thankfully, a heroic Quatermaster (Martin) broke the curse and freed the container. 

This year, our community brainstormed devious new ways to curse containers — and somehow voted that we theme this year's Halloween show after the famous U.S. children's TV Show _Blues Clues_, but, of course, making it evil. 

And thus we give you: __Cursed Containers 2: Blue Team's Clues and the Containers of Secrets__. This tutorial was created for a Twitch stream (twitch.tv/slimdevops) that aired Oct 31, 2022. 

# Secrets, Secrets Are No Fun 
As part of the Docker Desktop Extension Hackathon, we've also been messing with the Secrets Finder extension. 

Storing secrets inside containers — whether its passwords, private keys, or your social security number — is a big no-no for container security. After all, that stuff could be pushed to a public repo and be made accessible to every one! 

Thus, our two hosts "Not Jeff" (Martin) and "Not Blue" (Steven) must make sure their containers are free from secrets. But watch out! A demonic spirit has possessed "Not Magenta" (Pieter) and bewitched the containers with Not Jeff's top secret passwords. 

Can you help them find all the secrets? 

# The Clues 
## Clue 1: Beware Secrets in Production: They May Come Posed In Unusual Places
Arise, minions, you must get UP
And when you do, your secrets could be shared
If the hosts can manage a solution, 
Their secrets are ours fair and square. 

## Clue 2: To Pass This Test, You Must Check Your Sources
File, file, toil and bile, 
Potions brew, programs compile. 
When this brew gets pushed to Git, 
You secrets are mine; you must submit! 

## Clue 3: Finding This Secret Will Make You the ENVy Of the Neighborhood
Like Clue 2 but more dark and dreary, 
Hidden from view and full of worry. 
A careless COPY is all we need
To get the secrets in this deed. 

## Clue 4: 
This key secures the your treats from dirty little tricks, 
But hiding it from view takes some random little flicks. 
My powers wane and they are hard to code; 
If this secret is found, I'll hit the road. 


## Bonus Clue 5: Beware New Builds, They Can Be A Fright
So you have a safe container
And are ready to ship to prod
But be wary any new sha
They could be a bit odd


# .env file
# ENV var in Dockerfile 
# ENV var in Docker Compose
# hardcoded in application 
# private key 
# in slim container
