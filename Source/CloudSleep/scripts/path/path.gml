globalvar grid, gridCellSize, gridOffsetXAdd, gridOffsetYAdd;
gridCellSize = 32;

gridOffsetXAdd = 0;
gridOffsetYAdd = 0;

var gridsize = [
	0,
	0,
	6784 / 32,
	5504 / 32
];
grid = mp_grid_create(gridsize[0], gridsize[1], gridsize[2], gridsize[3], gridCellSize, gridCellSize);

