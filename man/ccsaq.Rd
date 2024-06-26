% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/ccsaq.R
\name{ccsaq}
\alias{ccsaq}
\title{Conservative Convex Separable Approximation with Affine Approximation plus
Quadratic Penalty}
\usage{
ccsaq(
  x0,
  fn,
  gr = NULL,
  lower = NULL,
  upper = NULL,
  hin = NULL,
  hinjac = NULL,
  nl.info = FALSE,
  control = list(),
  deprecatedBehavior = TRUE,
  ...
)
}
\arguments{
\item{x0}{starting point for searching the optimum.}

\item{fn}{objective function that is to be minimized.}

\item{gr}{gradient of function \code{fn}; will be calculated numerically if
not specified.}

\item{lower, upper}{lower and upper bound constraints.}

\item{hin}{function defining the inequality constraints, that is
\code{hin>=0} for all components.}

\item{hinjac}{Jacobian of function \code{hin}; will be calculated
numerically if not specified.}

\item{nl.info}{logical; shall the original NLopt info been shown.}

\item{control}{list of options, see \code{nl.opts} for help.}

\item{deprecatedBehavior}{logical; if \code{TRUE} (default for now), the old
behavior of the Jacobian function is used, where the equality is \eqn{\ge 0}
instead of \eqn{\le 0}. This will be reversed in a future release and
eventually removed.}

\item{...}{additional arguments passed to the function.}
}
\value{
List with components:
\item{par}{the optimal solution found so far.}
\item{value}{the function value corresponding to \code{par}.}
\item{iter}{number of (outer) iterations, see \code{maxeval}.}
\item{convergence}{integer code indicating successful completion (> 1)
or a possible error number (< 0).}
\item{message}{character string produced by NLopt and giving additional
information.}
}
\description{
This is a variant of CCSA ("conservative convex separable approximation")
which, instead of constructing local MMA approximations, constructs simple
quadratic approximations (or rather, affine approximations plus a quadratic
penalty term to stay conservative)
}
\note{
``Globally convergent'' does not mean that this algorithm converges to
the global optimum; it means that it is guaranteed to converge to some local
minimum from any feasible starting point.
}
\examples{

##  Solve the Hock-Schittkowski problem no. 100 with analytic gradients
##  See https://apmonitor.com/wiki/uploads/Apps/hs100.apm

x0.hs100 <- c(1, 2, 0, 4, 0, 1, 1)
fn.hs100 <- function(x) {(x[1] - 10) ^ 2 + 5 * (x[2] - 12) ^ 2 + x[3] ^ 4 +
                         3 * (x[4] - 11) ^ 2 + 10 * x[5] ^ 6 + 7 * x[6] ^ 2 +
                         x[7] ^ 4 - 4 * x[6] * x[7] - 10 * x[6] - 8 * x[7]}

hin.hs100 <- function(x) {c(
2 * x[1] ^ 2 + 3 * x[2] ^ 4 + x[3] + 4 * x[4] ^ 2 + 5 * x[5] - 127,
7 * x[1] + 3 * x[2] + 10 * x[3] ^ 2 + x[4] - x[5] - 282,
23 * x[1] + x[2] ^ 2 + 6 * x[6] ^ 2 - 8 * x[7] - 196,
4 * x[1] ^ 2 + x[2] ^ 2 - 3 * x[1] * x[2] + 2 * x[3] ^ 2 + 5 * x[6] -
 11 * x[7])
}

gr.hs100 <- function(x) {
 c( 2 * x[1] - 20,
   10 * x[2] - 120,
    4 * x[3] ^ 3,
    6 * x[4] - 66,
   60 * x[5] ^ 5,
   14 * x[6] - 4 * x[7] - 10,
    4 * x[7] ^ 3 - 4 * x[6] - 8)
}

hinjac.hs100 <- function(x) {
  matrix(c(4 * x[1], 12 * x[2] ^ 3, 1, 8 * x[4], 5, 0, 0,
           7, 3, 20 * x[3], 1, -1, 0, 0,
           23, 2 * x[2], 0, 0, 0, 12 * x[6], -8,
           8 * x[1] - 3 * x[2], 2 * x[2] - 3 * x[1], 4 * x[3], 0, 0, 5, -11),
           nrow = 4, byrow = TRUE)
}

##  The optimum value of the objective function should be 680.6300573
##  A suitable parameter vector is roughly
##  (2.330, 1.9514, -0.4775, 4.3657, -0.6245, 1.0381, 1.5942)

# Results with exact Jacobian
S <- ccsaq(x0.hs100, fn.hs100, gr = gr.hs100,
      hin = hin.hs100, hinjac = hinjac.hs100,
      nl.info = TRUE, control = list(xtol_rel = 1e-8),
      deprecatedBehavior = FALSE)

# Results without Jacobian
S <- ccsaq(x0.hs100, fn.hs100, hin = hin.hs100,
      nl.info = TRUE, control = list(xtol_rel = 1e-8),
      deprecatedBehavior = FALSE)

}
\references{
Krister Svanberg, ``A class of globally convergent optimization
methods based on conservative convex separable approximations,'' SIAM J.
Optim. 12 (2), p. 555-573 (2002).
}
\seealso{
\code{\link{mma}}
}
