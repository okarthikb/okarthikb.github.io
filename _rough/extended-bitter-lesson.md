---
title: "More Bitter? The Extended Bitter Lesson"
date: 2024-01-01
---

The scope of the bitter lesson is larger than most people believe it to be, I think.

People only believe it for one part of the stack, i.e., modelling.

Except look at any AI agent repo and it's so many hand-coded rules to interface the model with the real world, hooking it with APIs and such.

For example, think what you need to make an LLM do what the Microsoft engineer did to catch the recent xz utils backdoor.

The piece of information that gave away the issue was an extra 500ms delay plus remembering some complaint from weeks past. How long before it becomes common to use a single LLM context for weeks on end? Is that even feasible? Will something like ChatGPT memory suffice? I doubt. But we'll see.

[Tweet by @haxrob about the xz backdoor being foiled by 500ms of latency](https://twitter.com/haxrob/status/1773937085524979870)

To make an LLM agent do this, you'd hand-code the timestamps in the context for every command.

And hope that the model (Claude Opus could, probably) might catch the extra time it took to run the command.

"I notice that the last ssh command took longer to run."

No human has an inner monologue like this. They would just silently notice and would start investigating.

You're processing information like this all the time subconsciously.

You don't notice it and only notice your frontal thoughts when solving a hard abstract reasoning problem.

So LLMs impress us when they do this too, doing math/competitive programming. So we're surprised by low SWE-bench scores.

This is precisely what Moravec's paradox tells us: what is easy for us is hard for machines and vice versa, because we don't realize that a lot of things we do were optimized to the subconscious level by evolution over millennia. E.g., abstract reasoning easy, perception hard.

Having an intuitive sense of time is one such old perception skill in animals, which LLMs by default don't have without augmentation (like putting the date in the system prompt or timestamps at regular intervals or once every message completion to keep track of time during token generation). While we need to hand-code these percepts into the system, evolution already spent eons engineering biology to the point it got so good we ignore it.

Put another way, I think this is a central question: contra Yann, can we somehow augment LLMs to solve the perception and episodic memory bottleneck (long context kind of solves it) or is Yann right and we need to move away from LLMs for real world autonomous systems? I don't really know. Not enough robotics knowledge to answer. A good exercise might however be to project future hardware specs, context lengths, and other metrics and do some [back of the envelope calcs](https://kipp.ly/transformer-inference-arithmetic/) to gauge what might be possible.

Below is copy-pasted from the Moravec's paradox Wikipedia page:

**Moravec's paradox** is the observation in artificial intelligence and robotics that, contrary to traditional assumptions, reasoning requires very little computation, but sensorimotor and perception skills require enormous computational resources. The principle was articulated by Hans Moravec, Rodney Brooks, Marvin Minsky and others in the 1980s. Moravec wrote in 1988, "it is comparatively easy to make computers exhibit adult level performance on intelligence tests or playing checkers, and difficult or impossible to give them the skills of a one-year-old when it comes to perception and mobility."

Similarly, Minsky emphasized that the most difficult human skills to reverse engineer are those that are below the level of conscious awareness. "In general, we're least aware of what our minds do best", he wrote, and added "we're more aware of simple processes that don't work well than of complex ones that work flawlessly." Steven Pinker wrote in 1994 that "the main lesson of thirty-five years of AI research is that the hard problems are easy and the easy problems are hard."

One possible explanation of the paradox, offered by Moravec, is based on evolution. All human skills are implemented biologically, using machinery designed by the process of natural selection. In the course of their evolution, natural selection has tended to preserve design improvements and optimizations. The older a skill is, the more time natural selection has had to improve the design. Abstract thought developed only very recently, and consequently, we should not expect its implementation to be particularly efficient.

As Moravec writes:

> Encoded in the large, highly evolved sensory and motor portions of the human brain is a billion years of experience about the nature of the world and how to survive in it. The deliberate process we call reasoning is, I believe, the thinnest veneer of human thought, effective only because it is supported by this much older and much more powerful, though usually unconscious, sensorimotor knowledge. We are all prodigious olympians in perceptual and motor areas, so good that we make the difficult look easy. Abstract thought, though, is a new trick, perhaps less than 100 thousand years old. We have not yet mastered it. It is not all that intrinsically difficult; it just seems so when we do it.

A compact way to express this argument would be:

- We should expect the difficulty of reverse-engineering any human skill to be roughly proportional to the amount of time that skill has been evolving in animals.
- The oldest human skills are largely unconscious and so appear to us to be effortless.
- Therefore, we should expect skills that appear effortless to be difficult to reverse-engineer, but skills that require effort may not necessarily be difficult to engineer at all.

Some examples of skills that have been evolving for millions of years: recognizing a face, moving around in space, judging people's motivations, catching a ball, recognizing a voice, setting appropriate goals, paying attention to things that are interesting; anything to do with perception, attention, visualization, motor skills, social skills and so on.

Some examples of skills that have appeared more recently: mathematics, engineering, games, logic and scientific reasoning. These are hard for us because they are not what our bodies and brains were primarily evolved to do. These are skills and techniques that were acquired recently, in historical time, and have had at most a few thousand years to be refined, mostly by cultural evolution.
