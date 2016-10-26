#using lme4 to fit mixed models
install.packages(lme4)
library(lme4)

# built-in dataset that's good to try
data(ChickWeight)
head(ChickWeight)

# Only one observation per time/animal,
# so let's create some grouping factors:

# Let's divide chicks into ARBITRARY groups.
# Diets are in order, but we want some in each group.
# An example of lapply in the wild! Step through a table of diets
group_list <- lapply(table(diet), function(i) rep(1:4,ceiling(i/4)))
# we had to round up because there were some missing chicks.
# we need to remove the extra corresponding elements from the group_list
group_list[[4]] <- group_list[[4]][1:118]
# this is the lazy way to fix it.
# note how I referenced the vector within the list.
cgroup <- unlist(group_list)
# make sure that each chick cgroup includes each diet
# table(cgroup,diet)  # looks good

# divide times into groups as well
tgroup <- cut(ChickWeight$Time,
              seq(0,21,by=7) )
# confirm the other tables are filled out
table(cgroup,tgroup)
table(tgroup,diet)  # looks fine

# make free-floating copies of final var
weight <- ChickWeight$weight

# Step 1: Make a regular glm 
glm.0 <- glm(weight ~ diet)
summary(glm.0)

# Random effect of time group
r.tgroup <- lmer(weight ~ diet + (1|tgroup) )
summary(r.tgroup)
class(cgroup)
# Random effect of chick group
r.cgroup <- lmer(weight ~ diet + (1|cgroup) )
summary(r.cgroup)
# Fixed effect of time group - just glm
f.tgroup <- glm(weight ~ diet + tgroup )
summary(f.tgroup)
### Which random effect has larger variance, why?

# Using a random effect of tgroup on diet
r.tgroup2 <- lmer(weight ~ diet + (diet|tgroup) )
summary(r.tgroup2)



