# pwsh/Base.Docs/configs/hindsight.yml

The hindsight log the hindsight-log skill keeps: the same rolling-log shape as `learnings.yml`, one
[LearningsConfig](../types/learnings-config.md) instance each, in its own folder with its own file prefix and title. Every other key takes
the default declared once on `LearningsConfig`. `Add-SessionLearning -Log hindsight` appends to it.
