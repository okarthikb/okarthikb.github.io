---
title: "Stochastic Operator Notes: Diffusions, Flows, and Inference"
date: 2026-02-20
---

### Why this post

This is a deliberate stress test for markdown rendering in this site. It includes dense display math with `\tag`, long equations that should horizontally scroll on narrow screens, inline math like $\nabla_x \log p_t(x)$, code blocks, plain-text outputs, images with captions, and external embeds.

### Setup

We start from an Ito SDE in $\mathbb{R}^d$:

$$
\mathrm{d}x_t = f(x_t,t)\,\mathrm{d}t + G(t)\,\mathrm{d}w_t,\qquad x_0 \sim p_0 \tag{1}
$$

with diffusion tensor $a(t)=G(t)G(t)^\top$ and Fokker-Planck equation

$$
\partial_t p_t(x) = -\nabla_x\!\cdot\!\left(f(x,t)p_t(x)\right) + \frac{1}{2}\sum_{i,j=1}^d \partial_{x_i}\partial_{x_j}\!\left(a_{ij}(t)p_t(x)\right) \tag{2}
$$

The infinitesimal generator and semigroup are

$$
\mathcal{L}_t\varphi(x)=f(x,t)^\top\nabla\varphi(x)+\frac12\operatorname{tr}\!\left(a(t)\nabla^2\varphi(x)\right),\qquad (P_{s,t}\varphi)(x)=\mathbb{E}[\varphi(x_t)\mid x_s=x] \tag{3}
$$

### Reverse process and long objectives

For score-based modeling with isotropic scalar diffusion $g(t)$:

$$
\mathrm{d}x_t = \left[f(x_t,t)-g(t)^2\nabla_x\log p_t(x_t)\right]\mathrm{d}t + g(t)\,\mathrm{d}\bar w_t \tag{4}
$$

A long training objective with higher-order regularization:

$$
\mathcal{J}(\theta)=\mathbb{E}_{t\sim\mathcal U[\epsilon,1],\,x_0\sim p_0,\,\xi\sim\mathcal N(0,I)}\left[w(t)\left\|s_\theta\!\left(\alpha_t x_0+\sigma_t\xi,t,\mathrm{ctx}\!\left(x_0,\nabla\log p_t,\nabla^2\log p_t,\int_0^t\!\!\|\nabla\log p_s(x_s)\|_2^2\,\mathrm ds\right)\right)+\frac{\xi}{\sigma_t}\right\|_2^2+\lambda_1\|\nabla\!\cdot\!s_\theta\|_2^2+\lambda_2\|\nabla^2\!\cdot\!s_\theta\|_F^2\right] \tag{5}
$$

The probability-flow ODE sharing marginals with (4):

$$
\frac{\mathrm d x_t}{\mathrm d t}=f(x_t,t)-\frac12 g(t)^2\nabla_x\log p_t(x_t) \tag{6}
$$

### Measure transport and control

For drift perturbation $u_t$ under a reference Wiener measure, Girsanov gives

$$
\frac{\mathrm d\mathbb P^u}{\mathrm d\mathbb P}\Bigg|_{\mathcal F_T}=\exp\!\left(\int_0^T u_t^\top\,\mathrm dw_t-\frac12\int_0^T \|u_t\|_2^2\,\mathrm dt\right),\qquad \mathrm d x_t=b(x_t,t)\,\mathrm dt+\sigma(x_t,t)(u_t\,\mathrm dt+\mathrm d w_t) \tag{7}
$$

A Schrodinger bridge style dynamic problem:

$$
\inf_{(\rho_t,v_t)}\int_0^1\!\int_{\mathbb R^d}\frac12\|v_t(x)\|_2^2\rho_t(x)\,\mathrm dx\,\mathrm dt\quad\text{s.t.}\quad \partial_t\rho_t+\nabla\!\cdot(\rho_t v_t)-\frac{\varepsilon}{2}\Delta\rho_t=0,\ \rho_0=\mu,\ \rho_1=\nu \tag{8}
$$

Stochastic control HJB with quadratic control cost:

$$
-\partial_t V(x,t)=\inf_{u\in\mathbb R^m}\left\{\ell(x,u,t)+\nabla V(x,t)^\top\big(f(x,t)+B(x,t)u\big)+\frac12\operatorname{tr}\!\big(a(x,t)\nabla^2V(x,t)\big)\right\},\quad V(x,T)=\phi(x) \tag{9}
$$

### Variational identities

A dense ELBO form with pathwise and KL terms:

$$
\log p_\theta(x)\ge\mathbb E_{q_\phi(z\mid x)}[\log p_\theta(x\mid z)]-D_{\mathrm{KL}}\!\big(q_\phi(z\mid x)\|p(z)\big)=\mathbb E_{\epsilon\sim\mathcal N(0,I)}\!\left[\log p_\theta\!\big(x\mid\mu_\phi(x)+L_\phi(x)\epsilon\big)\right]-\frac12\sum_{i=1}^k\!\left(\mu_i^2+\sigma_i^2-\log\sigma_i^2-1\right) \tag{10}
$$

Gaussian KL in full-covariance matrix form:

$$
D_{\mathrm{KL}}\!\left(\mathcal N(\mu_q,\Sigma_q)\|\mathcal N(\mu_p,\Sigma_p)\right)=\frac12\left[\operatorname{tr}(\Sigma_p^{-1}\Sigma_q)+(\mu_p-\mu_q)^\top\Sigma_p^{-1}(\mu_p-\mu_q)-k+\log\frac{\det\Sigma_p}{\det\Sigma_q}\right] \tag{11}
$$

JKO step for Wasserstein gradient flow:

$$
\rho^{k+1}=\arg\min_{\rho\in\mathcal P_2(\mathbb R^d)}\left\{\mathcal F(\rho)+\frac{1}{2\tau}W_2^2(\rho,\rho^k)\right\},\qquad \mathcal F(\rho)=\int V\,\mathrm d\rho+\beta\int \rho\log\rho\,\mathrm dx \tag{12}
$$

### Operator viewpoint

A resolvent identity that shows up in implicit schemes:

$$
(\lambda I-\mathcal L)^{-1}=\int_0^\infty e^{-\lambda t}e^{t\mathcal L}\,\mathrm dt,\qquad \Re(\lambda)>\omega_0(\mathcal L) \tag{13}
$$

Discretized kernel system with Tikhonov regularization:

$$
(K+\lambda I)\alpha=y,\qquad K_{ij}=k(x_i,x_j),\qquad \widehat f(\cdot)=\sum_{i=1}^n\alpha_i k(x_i,\cdot) \tag{14}
$$

### Python block (highlighted)

```python
import torch

def euler_maruyama_reverse(x_t, t, dt, score_fn, drift_fn, g_t):
    """Reverse-time Euler-Maruyama step."""
    z = torch.randn_like(x_t)
    drift = drift_fn(x_t, t) - (g_t ** 2) * score_fn(x_t, t)
    mean = x_t + drift * dt
    noise = g_t * torch.sqrt(torch.tensor(abs(dt), device=x_t.device)) * z
    return mean + noise


def cg_solve(matvec, b, x0, iters=32, tol=1e-8):
    x = x0.clone()
    r = b - matvec(x)
    p = r.clone()
    rs_old = torch.dot(r, r)
    for _ in range(iters):
        Ap = matvec(p)
        alpha = rs_old / (torch.dot(p, Ap) + 1e-12)
        x = x + alpha * p
        r = r - alpha * Ap
        rs_new = torch.dot(r, r)
        if torch.sqrt(rs_new) < tol:
            break
        p = r + (rs_new / (rs_old + 1e-12)) * p
        rs_old = rs_new
    return x
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

### Notebook-style output block

<pre class="execution-output"><code>tensor([0.0017, 0.0031, 0.0058, 0.0102])
shape = torch.Size([4])
cg residual norm = 7.3e-09</code></pre>

### Figure with caption

<figure>
  <img src="/images/cascades.png" alt="Illustration of LM cascades">
  <figcaption>LM cascades and verifier-style decomposition of reasoning subproblems</figcaption>
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

### References

1. [Score-Based Generative Modeling through Stochastic Differential Equations](https://arxiv.org/abs/2011.13456)
2. [Denoising Diffusion Probabilistic Models](https://arxiv.org/abs/2006.11239)
3. [A simple explanation of probability flow ODEs](https://lilianweng.github.io/posts/2021-07-11-diffusion-models/)
4. [Diffusion notes PDF](/pdf/diffusion.pdf)
