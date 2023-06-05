
<!-- README.md is generated from README.Rmd. Please edit that file -->

# tidypolars

------------------------------------------------------------------------

:warning: If you’re looking for the Python package “tidypolars” by Mark
Fairbanks, you’re on the wrong repo. The right one is here:
[markfairbanks/tidypolars](https://github.com/markfairbanks/tidypolars)
:warning:

------------------------------------------------------------------------

`polars` (both the Rust source and the R implementation) are amazing
packages. I won’t argue here for the interest of using `polars`, there
are already a lot of resources on [its
website](https://rpolars.github.io/).

One characteristic of `polars` is that its syntax is 1) extremely
verbose, and 2) very close to the `pandas` syntax in Python. While this
makes it quite easy to read, it is **yet another syntax to learn** for R
users that are accustomed so far to either base R, `data.table` or the
`tidyverse`.

The objective of `tidypolars` is to **provide functions that are very
close to the `tidyverse` ones** but that call the `polars` functions
under the hood so that we don’t lose anything of its capacities.
Morevoer, the objective is to keep `tidypolars` **dependency-free** with
the exception of `polars` itself (which has no dependencies).

## General syntax

Overall, you only need to add `pl_` as a prefix to the `tidyverse`
function you’re used to. For example, `dplyr::mutate()` modifies classic
`R` dataframes, and `tidypolars::pl_mutate()` modifies `polars`’
`DataFrame`s and `LazyFrame`s.

## Example

``` r
library(polars)
library(tidypolars)

pl_test <- pl$DataFrame(iris)
pl_test
#> shape: (150, 5)
#> ┌──────────────┬─────────────┬──────────────┬─────────────┬───────────┐
#> │ Sepal.Length ┆ Sepal.Width ┆ Petal.Length ┆ Petal.Width ┆ Species   │
#> │ ---          ┆ ---         ┆ ---          ┆ ---         ┆ ---       │
#> │ f64          ┆ f64         ┆ f64          ┆ f64         ┆ cat       │
#> ╞══════════════╪═════════════╪══════════════╪═════════════╪═══════════╡
#> │ 5.1          ┆ 3.5         ┆ 1.4          ┆ 0.2         ┆ setosa    │
#> │ 4.9          ┆ 3.0         ┆ 1.4          ┆ 0.2         ┆ setosa    │
#> │ 4.7          ┆ 3.2         ┆ 1.3          ┆ 0.2         ┆ setosa    │
#> │ 4.6          ┆ 3.1         ┆ 1.5          ┆ 0.2         ┆ setosa    │
#> │ …            ┆ …           ┆ …            ┆ …           ┆ …         │
#> │ 6.3          ┆ 2.5         ┆ 5.0          ┆ 1.9         ┆ virginica │
#> │ 6.5          ┆ 3.0         ┆ 5.2          ┆ 2.0         ┆ virginica │
#> │ 6.2          ┆ 3.4         ┆ 5.4          ┆ 2.3         ┆ virginica │
#> │ 5.9          ┆ 3.0         ┆ 5.1          ┆ 1.8         ┆ virginica │
#> └──────────────┴─────────────┴──────────────┴─────────────┴───────────┘

pl_test |> 
  pl_filter(Species == "setosa") |> 
  pl_arrange(Sepal.Width, -Sepal.Length)
#> shape: (50, 5)
#> ┌──────────────┬─────────────┬──────────────┬─────────────┬─────────┐
#> │ Sepal.Length ┆ Sepal.Width ┆ Petal.Length ┆ Petal.Width ┆ Species │
#> │ ---          ┆ ---         ┆ ---          ┆ ---         ┆ ---     │
#> │ f64          ┆ f64         ┆ f64          ┆ f64         ┆ cat     │
#> ╞══════════════╪═════════════╪══════════════╪═════════════╪═════════╡
#> │ 4.5          ┆ 2.3         ┆ 1.3          ┆ 0.3         ┆ setosa  │
#> │ 4.4          ┆ 2.9         ┆ 1.4          ┆ 0.2         ┆ setosa  │
#> │ 5.0          ┆ 3.0         ┆ 1.6          ┆ 0.2         ┆ setosa  │
#> │ 4.9          ┆ 3.0         ┆ 1.4          ┆ 0.2         ┆ setosa  │
#> │ …            ┆ …           ┆ …            ┆ …           ┆ …       │
#> │ 5.8          ┆ 4.0         ┆ 1.2          ┆ 0.2         ┆ setosa  │
#> │ 5.2          ┆ 4.1         ┆ 1.5          ┆ 0.1         ┆ setosa  │
#> │ 5.5          ┆ 4.2         ┆ 1.4          ┆ 0.2         ┆ setosa  │
#> │ 5.7          ┆ 4.4         ┆ 1.5          ┆ 0.4         ┆ setosa  │
#> └──────────────┴─────────────┴──────────────┴─────────────┴─────────┘

pl_test |> 
  pl_mutate(
    Sepal.Total = Sepal.Length + Sepal.Width,
    Petal.Total = Petal.Length + Petal.Width
  ) |> 
  pl_select(ends_with("Total"))
#> shape: (150, 2)
#> ┌─────────────┬─────────────┐
#> │ Sepal.Total ┆ Petal.Total │
#> │ ---         ┆ ---         │
#> │ f64         ┆ f64         │
#> ╞═════════════╪═════════════╡
#> │ 8.6         ┆ 1.6         │
#> │ 7.9         ┆ 1.6         │
#> │ 7.9         ┆ 1.5         │
#> │ 7.7         ┆ 1.7         │
#> │ …           ┆ …           │
#> │ 8.8         ┆ 6.9         │
#> │ 9.5         ┆ 7.2         │
#> │ 9.6         ┆ 7.7         │
#> │ 8.9         ┆ 6.9         │
#> └─────────────┴─────────────┘
```

# FAQ

## Is `tidypolars` slower than `polars`?

No, or just marginally. The objective of `tidypolars` is *not* to modify
the data, simply to translate the `tidyverse` syntax to `polars` syntax.
`polars` is still in charge of doing all the data manipulations under
the hood.

Therefore, there might be minor overhead because we still need to parse
the expressions and rewrite them in `polars` syntax but this should be
extremely marginal.

## Am I stuck with `tidypolars`?

No, as said above, `tidypolars` just changes one syntax to another but
it doesn’t touch the data itself. So if for some reason you want to go
back to a “raw” `polars` syntax later in your code, you’re free to do so
because `tidypolars` will always return `DataFrame`s, `LazyFrame`s or
`Series`.

## Do I still need to load `polars`?

Yes, because `tidypolars` doesn’t provide any functions to create
`polars` `DataFrame` or `LazyFrame`, or to read data. You’ll still need
to use `polars` for this.

## Can I see some benchmarks?

Sure but take them with a grain of salt: these small benchmarks may not
be representative of real-life scenarios and don’t necessarily use the
full capacities of other packages (e.g keyed `data.table`s). You should
refer to [DuckDB benchmarks](https://duckdblabs.github.io/db-benchmark/)
for more serious ones.

``` r
library(polars)
library(tidypolars)
library(dplyr)
#> 
#> Attaching package: 'dplyr'
#> The following objects are masked from 'package:stats':
#> 
#>     filter, lag
#> The following objects are masked from 'package:base':
#> 
#>     intersect, setdiff, setequal, union
library(data.table)
#> 
#> Attaching package: 'data.table'
#> The following objects are masked from 'package:dplyr':
#> 
#>     between, first, last

test <- data.frame(
  grp = sample(letters, 1e7, TRUE),
  val1 = sample(1:1000, 1e7, TRUE),
  val2 = sample(1:1000, 1e7, TRUE)
)

pl_test <- pl$DataFrame(test)
dt_test <- as.data.table(test)

bench::mark(
  polars = pl_test$
    groupby("grp")$
    agg(
      pl$col('val1')$mean()$alias('x'), 
      pl$col('val2')$sum()$alias('y')
    ),
  tidypolars = pl_test |> 
    pl_group_by(grp) |> 
    pl_summarize(
      x = mean(val1),
      y = sum(val2)
    ),
  dplyr = test |> 
    group_by(grp) |> 
    summarize(
      x = mean(val1),
      y = sum(val2)
    ),
  data.table = dt_test[, .(x = mean(val1), y = sum(val2)), by = grp],
  check = FALSE
)
#> Warning: Some expressions had a GC in every iteration; so filtering is
#> disabled.
#> # A tibble: 4 × 6
#>   expression      min   median `itr/sec` mem_alloc `gc/sec`
#>   <bch:expr> <bch:tm> <bch:tm>     <dbl> <bch:byt>    <dbl>
#> 1 polars       76.7ms   77.8ms     12.8      138KB     0   
#> 2 tidypolars   78.5ms   80.6ms     12.4      226KB     0   
#> 3 dplyr       320.7ms  323.3ms      3.09     242MB     3.09
#> 4 data.table  220.5ms  270.5ms      3.70     273MB     5.55

bench::mark(
  polars = pl_test$
    filter(pl$col("grp") == "a" | pl$col("grp") == "b"),
  tidypolars = pl_test |> 
    pl_filter(grp == "a" | grp == "b"),
  dplyr = test |> 
    filter(grp %in% c("a", "b")),
  data.table = dt_test[grp %chin% c("a", "b")],
  check = FALSE
)
#> # A tibble: 4 × 6
#>   expression      min   median `itr/sec` mem_alloc `gc/sec`
#>   <bch:expr> <bch:tm> <bch:tm>     <dbl> <bch:byt>    <dbl>
#> 1 polars       47.4ms   60.1ms     16.7       15KB     0   
#> 2 tidypolars   49.5ms   61.4ms     16.9     11.4KB     0   
#> 3 dplyr       232.9ms  232.9ms      4.29   281.9MB     8.59
#> 4 data.table   25.1ms   26.4ms     37.7    100.7MB     4.71
```
