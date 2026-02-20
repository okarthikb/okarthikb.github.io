---
title: "Control Vectors vs Sparse Autoencoders"
date: 2024-01-01
---

I just spent some time reading Vgel's RepEng library post and Anthropic's post to understand the differences.

Both share conceptual similarities, but the implementations are different. Anthropic's work is more powerful (and compute demanding). You could say Anthropic is doing (near) exactly what control vectors are approximating.

Vgel also briefly discusses this in her blog post.

## Concept

Consider the outputs of a model's layers.

The outputs are vectors, an abstract amalgamation of the previous context (or any other input, this is not transformer-specific). Suppose you had contrasting inputs for some feature you wanted to control, like how happy or sad the model is.

You collect the "happy" layer outputs (that is, layer outputs for inputs prompting the model to be happy) and the "sad" outputs. Take the difference. You now have a set of difference vectors.

You perform Principal Component Analysis (PCA) on these vectors and take the most principal component. This is a vector approximating the axis along which the model layer outputs vary the most for happy and sad prompts. This component is the happy-sad control vector.

Imagine a model layer output $y \in \mathbb{R}^d$. The control vector $v \in \mathbb{R}^d$ is also a vector in $\mathbb{R}^d$. By multiplying the control vector by a large positive number and adding it to each layer, you make the model happy. A large negative number makes the model sad.

What you did here is find a direction (corresponding to some feature) along which to steer a model's activations to control that feature in the model's output. The way you found this direction (approximately) is by collecting a dataset of activations that you know to differ significantly in that direction, and applying a classic machine learning feature extraction method (PCA) to find the direction in which the activations differ the most (the principal component of the differences).

Since you're only finding an approximation here, you end up not just controlling the one feature you care about (happy-sad), but also interfering with other features, most times to the detriment.

## Improving the Approximation

Can we find a better approximation? What if, instead of using a classic ML method like PCA, you used something like sparse autoencoders, which is a deep learning-based feature extraction method?

That's what Anthropic did. They trained a sparse autoencoder (SAE) with a hidden state size much larger than the model dimension $d_{\text{model}}$, and trained the SAE to reconstruct the activation.

The setup is that they take some activation (layer output), and train the SAE by minimizing the error between $\text{SAE}(x)$ and $x$.

The hidden state is quite large, so each individual element in the hidden state of the SAE is more likely to correspond to a specific direction in feature space. By tweaking this single element up and down, you can control the model behavior.

The implementation is: you input the activation, you get $\text{SAE}(x) = x_{\text{pred}}$, an approximation of $x$, and let $e = x - x_{\text{pred}}$.

Without interventions, in this procedure you would replace activation $x$ with:

$$\text{SAE}(x) + e = x_{\text{pred}} + x - x_{\text{pred}} = x$$

With intervention, where you modify the hidden state element (neuron) corresponding to the feature, you get a modified output $x_{\text{intervened}}$, which is $\text{SAE}(x)$ with an element of the hidden state altered.

Now you replace $x$ with:

$$y = x_{\text{intervened}} + e$$

The "control vector" here is implicit:

$$v = y - x$$

The Anthropic post discusses all the implementation details. Vgel's code is good for control vectors, though it could benefit from more comments for shape annotations.
