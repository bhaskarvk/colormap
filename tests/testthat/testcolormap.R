library(colormap)

context('Colors')

test_that("Number of Colors match expectation", {
  expect_equal(length(colormap()),72)
  expect_equal(length(colormap(nshades = 10)),10)
  expect_equal(length(colormap(nshades = 3999)),3999)
})

test_that("Reverse works", {
  expect_equal(rev(colormap()), colormap(reverse = T))
})
