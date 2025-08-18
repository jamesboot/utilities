# Create loupeR function
# Function for creating loupe files from Seurat objects
louper <- function(file, filetype, outdir, outname) {
  
  # Load object
  if (filetype == 'rds') {
    obj <- readRDS(file)
  } else if (filetype == 'qs') {
    obj <- qread(file)
  }
  
  # Gene Expression RNA assay
  assay <- obj[["RNA"]]
  
  # get counts matrix from either the old or newer formats of assay
  counts <- counts_matrix_from_assay(assay)
  
  # convert the count matrix, clusters, and projections into a Loupe file
  create_loupe(
    counts,
    clusters = select_clusters(obj),
    projections = select_projections(obj),
    output_dir = outdir,
    output_name = outname,
    force = T
  )
  
}