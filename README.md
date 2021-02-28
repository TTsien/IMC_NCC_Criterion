# IMC_NCC_Criterion
Classification criterion for neoadjuvant immunotherapy, developed by Ma Lab, NCC and Genecode Co. 

Step 1. define cell type group with density plot matrix and marker tsne
  - cancer cell group is defined by CK and beta-catenin expression
  - CD8+ T cell group is defined by CD8 expression
  - B cell group is defined by CD19 expression

Step 2. calculate cancer cell rating using provided model
  cancer cells with rating more than 0.6 are considered as potentially responsive cells
  percentages of responsive cancer cells of samples are calculated
  
Step 3. calculate infiltrating percentage of immune cells (B cell & CD4+ T cell)

Step 4. apply NCC criterion to determine inclusion of study subject
