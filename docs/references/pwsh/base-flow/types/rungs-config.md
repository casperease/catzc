# pwsh/Base.Flow/types/RungsConfig.cs

The typed record for `rungs.yml`, the promotion ladder, and the one declaration of its default ladder.

## The default ladder

When the file names no rungs, the ladder is `DefaultRungs`: main-uat, release-uat behind RC, pre-prod behind RBC, and prod behind the prod
approval gate. It is the one place a rung's environment is mapped, so remapping one, such as main-uat from dev to its own environment, is a
one-line edit there.
