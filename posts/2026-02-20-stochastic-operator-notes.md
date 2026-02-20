---
title: "Stochastic Operator Notes: Diffusions, Flows, and Inference"
date: 2026-02-20
---

### Why this post

This is a deliberate stress test for markdown rendering in this site. It includes dense display math with `\tag`, long equations that should horizontally scroll on narrow screens, inline math like $\nabla_x \log p_t(x)$, code blocks, plain-text outputs, images with captions, and external embeds.

### Setup

We start from an It\^o SDE in $\mathbb{R}^d$:

$$
\mathrm{d}x_t = f(x_t,t)\,\mathrm{d}t + g(t)\,\mathrm{d}w_t,\qquad x_0 \sim p_0 \tag{1}
$$

with Fokker-Planck evolution

$$
\partial_t p_t(x) = -\nabla_x \cdot \left(f(x,t)p_t(x)\right) + \frac{1}{2} g(t)^2 \Delta_x p_t(x). \tag{2}
$$

For score-based models, the reverse-time SDE is

$$
\mathrm{d}x_t = \left[f(x_t,t) - g(t)^2 \nabla_x \log p_t(x_t)\right] \mathrm{d}t + g(t)\,\mathrm{d}\bar w_t. \tag{3}
$$

### One intentionally long equation

The following objective is intentionally long to test responsive math scrolling and equation-tag behavior:

$$
\mathcal{L}(\theta)=\mathbb{E}_{t\sim\mathcal{U}[0,1],\,x_0\sim p_0,\,\epsilon\sim\mathcal{N}(0,I)}\left[\left\|\frac{x_t-\alpha_t x_0}{\sigma_t}-s_\theta\!\left(x_t,t,\mathrm{cond}\!\left(x_0,\nabla_x\log p_t(x_t),\nabla_x^2\log p_t(x_t),\int_0^t\|\nabla_x\log p_s(x_s)\|_2^2\,\mathrm{d}s\right)\right)\right\|_2^2 + \lambda\,\|\nabla_x\cdot s_\theta(x_t,t)\|_2^2\right]. \tag{4}
$$

### Variational view

Let $q(z\mid x)$ be a Gaussian encoder and $p_\theta(x\mid z)$ a decoder. The ELBO is

$$
\log p_\theta(x) \ge \mathbb{E}_{q(z\mid x)}\left[\log p_\theta(x\mid z)\right] - D_{\mathrm{KL}}\!\left(q(z\mid x)\,\|\,p(z)\right). \tag{5}
$$

A matrix form frequently used in proofs:

$$
D_{\mathrm{KL}}\!\left(\mathcal{N}(\mu_q,\Sigma_q)\,\|\,\mathcal{N}(\mu_p,\Sigma_p)\right)=\frac{1}{2}\left[\operatorname{tr}(\Sigma_p^{-1}\Sigma_q)+ (\mu_p-\mu_q)^\top \Sigma_p^{-1}(\mu_p-\mu_q)-k+\log\frac{\det \Sigma_p}{\det \Sigma_q}\right]. \tag{6}
$$

### Sparse linear algebra note

In operator-learning regimes, we often solve

$$
(K + \lambda I)\alpha = y
$$

where `K` is a large kernel matrix and `\lambda` is a Tikhonov term. In practice, we use `CG` with preconditioning rather than dense inverse routines.

### Python block (highlighted)

```python
import torch

def reverse_step(x_t, t, dt, score_fn, g_t):
    """Single Euler-Maruyama step for reverse-time SDE."""
    z = torch.randn_like(x_t)
    drift = -g_t**2 * score_fn(x_t, t)
    mean = x_t + drift * dt
    noise = g_t * torch.sqrt(torch.tensor(abs(dt), device=x_t.device)) * z
    return mean + noise
```

### Plaintext block (unhighlighted)

```text
index again

1: 0
2: 0
3: 0
4: 0
5: 3
6: 4
7: 7
8: 5
9: 6
```

### Notebook-style output block (custom class)

<pre class="execution-output"><code>tensor([0.0017, 0.0031, 0.0058, 0.0102])
shape = torch.Size([4])</code></pre>

### Figure with caption

<figure>
  <img src="/images/cascades.png" alt="Illustration of LM cascades">
  <figcaption>LM cascades and verifier-style decomposition of reasoning subproblems.</figcaption>
</figure>

### Plain markdown image

![Perception bottleneck refresher](/images/perception-bottleneck.jpg)

### X/Twitter embed

<blockquote class="twitter-tweet"><p lang="en" dir="ltr">Code Interpreter will be available to all ChatGPT Plus users over the next week.<br><br>It lets ChatGPT run code, optionally with access to files you&#39;ve uploaded. <a href="https://t.co/IjH5JBqe5B">pic.twitter.com/IjH5JBqe5B</a></p>&mdash; OpenAI (@OpenAI) <a href="https://twitter.com/OpenAI/status/1677015057316872192?ref_src=twsrc%5Etfw">July 6, 2023</a></blockquote>

### Iframe embed

<iframe
  src="https://www.youtube.com/embed/aircAruvnKk"
  title="Gradient descent explainer"
  style="width:min(100%, 720px); aspect-ratio:16/9; border:0;"
  loading="lazy"
  allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share"
  referrerpolicy="strict-origin-when-cross-origin"
  allowfullscreen>
</iframe>

### Conversation block

<div class="convo">

<div class="user">
<p>
Derive the probability-flow ODE corresponding to the VP SDE and state whether sampling is deterministic.
</p>
</div>

<div class="gpt">
<p>
The probability-flow ODE removes the stochastic term while preserving marginals:
</p>

$$
\frac{\mathrm{d}x_t}{\mathrm{d}t} = f(x_t,t) - \frac{1}{2}g(t)^2\nabla_x\log p_t(x_t). \tag{7}
$$

<p>
Sampling is deterministic given the terminal condition.
</p>
</div>

</div>

### References

1. [Score-Based Generative Modeling through Stochastic Differential Equations](https://arxiv.org/abs/2011.13456)
2. [Denoising Diffusion Probabilistic Models](https://arxiv.org/abs/2006.11239)
3. [A simple explanation of probability flow ODEs](https://lilianweng.github.io/posts/2021-07-11-diffusion-models/)
4. [Diffusion notes PDF](/pdf/diffusion.pdf)
