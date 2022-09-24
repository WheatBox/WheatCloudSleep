if(working) {
	if(surf == -1 || surface_exists(surf) == false) {
		MySurfCreate();
	}
	if(InstanceExists(obj_ourPhone)) {
		obj_ourPhone.myOurAppSurf = surf;
	}
} else {
	MySurfFree();
}

// SurfaceClear_surf(surf);

