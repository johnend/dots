# Geospatial arrays, predicates and raster coverage

Read when working with Shapely spatial queries, derived polygon boundaries, or polygon-clipped raster displays. The subnanometre tolerance below concerns floating-point boundary predicates, not source-data accuracy or a default tolerance for all coordinates.

- Use object-dtype arrays for empty Shapely spatial-index queries.
- Allow subnanometre floating-point tolerance in derived polygon-boundary predicates.
- Preserve observed partial boundary cells when clipping raster displays to polygon outlines.
