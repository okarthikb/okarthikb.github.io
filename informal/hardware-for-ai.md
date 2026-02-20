---
title: "Some Thoughts on Hardware for AI"
date: 2024-01-01
---

**TL;DR: It's not either/or. We'll have transformers and other architectures too.**

It depends on the task at hand. Making an ASIC for transformers doesn't preclude making one for other architectures. The primitives are mostly the same.

In fact, the Mamba inference step is simpler compared to transformers (see the mamba_step function in my notebook). It's just dot products and elementwise multiplication.

The real issue with relying solely on transformers requires examining their original purpose. If the goal is to bypass other approaches by generating tokens super fast and spawning numerous agents, letting sheer numbers do the heavy lifting for all tasks, that's likely a losing bet.

I recommend reading the Mamba paper's section on compression. It reflects deep thinking about hardware and architecture.

Transformers have many inductive biases that make them less general than often portrayed. Their perceived generality stems from easy-to-understand code and widespread use, but this can be misleading as it's restricted to a particular compute regime.

You'll hit walls when dealing with extremely long contexts and native multimodal reasoning and planning.

With text, you need to attend to every token because it's highly compressed. Transformers have a large state size, storing all previous keys and values for each layer.

This isn't necessary (and is performance-detrimental) when dealing with audio or video. These modalities are more compressible, allowing for real-time compression. You're not bound by context lengths of trillions of tokens, but can intelligently choose what to remember and forget in real time. This is crucial for episodic memory and general computer interfacing.

Mamba does this partly by having a constant state size, not a growing one, making it real-time by default.

Most of these models still use similar primitives, namely matrix multiplications. This is unlikely to change significantly.
