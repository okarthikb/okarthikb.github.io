---
title: "Mamba and the Future of AI Research"
date: 2024-01-01
---

Mamba may indicate the next phase of AI research.

This is not to say Mamba specifically beats transformers; rather, groundwork has already been laid for architectures that will excel on multimodal tasks and extremely long timescales (think on the scale of months or years) relative to today's models. In fact, one should think of Mamba and its state space siblings as being complementary to transformers. Tri and Albert go over the intuitions behind SSMs in [this video](https://www.youtube.com/watch?v=iUfUFKQLGBQ&si=aqRiLxDWAni1xg4i&t=217).

The real challenge is data and a suitable unsupervised objective, a combination that existed for LLMs to succeed. You see Ilya mention this on Dwarkesh, on why OpenAI gave up on robotics (because of no huge datasets for training).

Consider why [people aren't training LLMs on git diffs to teach it actual policies to automate software](https://x.com/mike64_t/status/1803939879279112401?s=46). It's because the diffs are mostly too redundant at the text level. This is in part why git works so well; small edits between commits mean very delta compressible. But this level of redundancy at the text level would hurt learning, and so humans don't learn writing software at the diff level. We do look at changes between iterations, but it's at the conceptual level, not the diff level, and we grasp the concepts while processing lots of high-dimensional and compressible information in real-time.

State space models are ideal for this, and the sort of fuzzy context compression over extremely long contexts they do is a much better model of what human brains do than transformers. Put simply, they're a much more general architecture when considering real-time multimodal data (transformers would likely still be used for text and similar data). And not only that, but for high-level control for agents and so forth (what people today call "orchestration" because they're too LLM-brained).

So the architecture is not the primary rate limiter for AI in the long run; it's compute and datasets, and these we can expect to follow steady superlinear curves.

It's a bit like the Nearcyan joke: while you wait for the model to drop, you can make all the frontend, and when the model drops, just plug it in.

Similarly, the architectures are there, and once enough compute comes by (both in datacenters and to regular users), people figure out how to make these large multimodal datasets for training and suitable objectives, you can just throw in the architecture after buffing out some issues.

I used to think a company working on transformers is a bear signal for AI. This is, in fact, not the case at all if we consult the holy plot. Transformers fall under the grey plot, and people choose it today for state-of-the-art general systems since it best fits with the current compute regime and market. State space models, JEPA, diffusion for planning, etc., fall under the red curve. They're more general architectures, but we have to wait for them to shine.

![AI Architecture Plot](/images/IMG_9051.jpeg)
