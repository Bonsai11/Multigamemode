function start ()
	boxobj = createObject(8838, 4540.775, -1243.921, 235.896, 0, 0, 0)
	boxobj1 = createObject(8838, 4540.775, -1243.921, 235.896, 0, 0, 15)
	boxobj2 = createObject(8838, 4540.775, -1243.921, 235.896, 0, 0, 30)
	boxobj3 = createObject(8838, 4540.775, -1243.921, 235.896, 0, 0, 45)
	boxobj4 = createObject(8838, 4540.775, -1243.921, 235.896, 0, 0, 60)
	boxobj5 = createObject(8838, 4540.775, -1243.921, 235.896, 0, 0, 75)
	boxobj6 = createObject(8838, 4540.775, -1243.921, 235.896, 0, 0, 90)
	boxobj7 = createObject(3095, 5067.34, -1197.904, 69.671, 0, 0, 0)
	boxobj8 = createObject(8838, 5062.295, -1143.362, 86.61, 0, 90, 90)
	boxobj9 = createObject(8838, 5067.446, -1143.409, 86.61, 0, 45, 90)
	boxobj10 = createObject(8838, 5072.521, -1143.506, 86.61, 0, 0, 90)
	boxobj11 = createObject(3095, 5067.535, -1088.856, 87.59, 0, 0, 0)
	boxobj12 = createObject(3502, 3965.152, -1860.36, 5.759, 0, 0, 90)
	boxobj13 = createObject(3502, 3956.45, -1860.356, 5.759, 0, 0, 90)
	boxobj14 = createObject(3502, 3947.765, -1860.348, 5.759, 0, 0, 90)
	boxobj15 = createObject(3502, 3939.439, -1860.344, 5.759, 0, 0, 90)
	boxobj16 = createObject(8838, 3907.943, -1860.634, 2.5, 0, 0, 0)
	boxobj17 = createObject(8838, 3907.943, -1860.634, 2.49, 0, 0, 15)
	boxobj18 = createObject(8838, 3907.943, -1860.634, 2.48, 0, 0, 30)
	boxobj19 = createObject(8838, 3907.943, -1860.634, 2.47, 0, 0, 45)
	boxobj20 = createObject(8838, 3907.943, -1860.634, 2.46, 0, 0, 60)
	boxobj21 = createObject(8838, 3907.943, -1860.634, 2.45, 0, 0, 75)
	boxobj22 = createObject(8838, 3907.943, -1860.634, 2.44, 0, 0, 90)
	boxobj23 = createObject(8838, 3864.409, -1999.869, 2.5, 0, 0, 0)
	boxobj24 = createObject(8838, 3864.409, -1999.869, 2.49, 0, 0, 15)
	boxobj25 = createObject(8838, 3864.409, -1999.869, 2.48, 0, 0, 30)
	boxobj26 = createObject(8838, 3864.409, -1999.869, 2.47, 0, 0, 45)
	boxobj27 = createObject(8838, 3864.409, -1999.869, 2.46, 0, 0, 60)
	boxobj28 = createObject(8838, 3864.409, -1999.869, 2.45, 0, 0, 75)
	boxobj29 = createObject(8838, 3864.409, -1999.869, 2.44, 0, 0, 90)
	cross()
	cross1()
	cross2()
	cross3()
	cross4()
	cross5()
end

function cross()
	moveObject(boxobj, 3000, 4540.775, -1243.921, 235.896, 0, 0, 90)
	moveObject(boxobj1, 3000, 4540.775, -1243.921, 235.896, 0, 0, 90)
	moveObject(boxobj2, 3000, 4540.775, -1243.921, 235.896, 0, 0, 90)
	moveObject(boxobj3, 3000, 4540.775, -1243.921, 235.896, 0, 0, 90)
	moveObject(boxobj4, 3000, 4540.775, -1243.921, 235.896, 0, 0, 90)
	moveObject(boxobj5, 3000, 4540.775, -1243.921, 235.896, 0, 0, 90)
	moveObject(boxobj6, 3000, 4540.775, -1243.921, 235.896, 0, 0, 90)
	setTimer(cross, 3000, 1)
end

function cross1(var)
	if var then
		moveObject(boxobj7, 6000, 5067.34, -1197.904, 91.841, 0, 0, 0)
		moveObject(boxobj11, 6000, 5067.535, -1088.856, 106.666, 0, 0, 0)
		setTimer(cross1, 7000, 1)
	else
		moveObject(boxobj7, 1500, 5067.34, -1197.904, 69.671, 0, 0, 0)
		moveObject(boxobj11, 1500, 5067.535, -1088.856, 87.601, 0, 0, 0)
		setTimer(cross1, 2500, 1, true)
	end
end

function cross2()
	moveObject(boxobj8, 9000, 5062.295, -1143.362, 86.61, 0, 90, 0)
	moveObject(boxobj9, 9000, 5067.446, -1143.409, 86.61, 0, 90, 0)
	moveObject(boxobj10, 9000, 5072.521, -1143.506, 86.61, 0, 90, 0)
	setTimer(cross2, 9000, 1)
end

function cross3(var)
	if var then
		moveObject(boxobj12, 1000, 3965.151, -1865.359, 5.759, 0, 0, 0)
		moveObject(boxobj13, 1000, 3956.45, -1855.356, 5.759, 0, 0, 0)
		moveObject(boxobj14, 1000, 3947.765, -1865.348, 5.759, 0, 0, 0)
		moveObject(boxobj15, 1000, 3939.438, -1855.343, 5.759, 0, 0, 0)
		setTimer(cross3, 3000, 1)
	else
		moveObject(boxobj12, 1000, 3965.151, -1860.36, 5.759, 0, 0, 0)
		moveObject(boxobj13, 1000, 3956.45, -1860.36, 5.759, 0, 0, 0)
		moveObject(boxobj14, 1000, 3947.765, -1860.36, 5.759, 0, 0, 0)
		moveObject(boxobj15, 1000, 3939.438, -1860.36, 5.759, 0, 0, 0)
		setTimer(cross3, 7000, 1, true)
	end
end

function cross4(var)
	if var then
		moveObject(boxobj16, 10000, 3907.943, -2000.634, 2.5, 0, 0, 180)
		moveObject(boxobj17, 10000, 3907.943, -2000.634, 2.49, 0, 0, 180)
		moveObject(boxobj18, 10000, 3907.943, -2000.634, 2.48, 0, 0, 180)
		moveObject(boxobj19, 10000, 3907.943, -2000.634, 2.47, 0, 0, 180)
		moveObject(boxobj20, 10000, 3907.943, -2000.634, 2.46, 0, 0, 180)
		moveObject(boxobj21, 10000, 3907.943, -2000.634, 2.45, 0, 0, 180)
		moveObject(boxobj22, 10000, 3907.943, -2000.634, 2.44, 0, 0, 180)
		setTimer(cross4, 11000, 1)
	else
		moveObject(boxobj16, 2000, 3907.943, -1860.634, 2.5, 0, 0, 180)
		moveObject(boxobj17, 2000, 3907.943, -1860.634, 2.49, 0, 0, 180)
		moveObject(boxobj18, 2000, 3907.943, -1860.634, 2.48, 0, 0, 180)
		moveObject(boxobj19, 2000, 3907.943, -1860.634, 2.47, 0, 0, 180)
		moveObject(boxobj20, 2000, 3907.943, -1860.634, 2.46, 0, 0, 180)
		moveObject(boxobj21, 2000, 3907.943, -1860.634, 2.45, 0, 0, 180)
		moveObject(boxobj22, 2000, 3907.943, -1860.634, 2.44, 0, 0, 180)
		setTimer(cross4, 3000, 1, true)
	end
end

function cross5(var)
	if var then
		moveObject(boxobj23, 10000, 3864.409, -1999.869, 44.745, 0, 0, 180)
		moveObject(boxobj24, 10000, 3864.409, -1999.869, 44.735, 0, 0, 180)
		moveObject(boxobj25, 10000, 3864.409, -1999.869, 44.725, 0, 0, 180)
		moveObject(boxobj26, 10000, 3864.409, -1999.869, 44.715, 0, 0, 180)
		moveObject(boxobj27, 10000, 3864.409, -1999.869, 44.705, 0, 0, 180)
		moveObject(boxobj28, 10000, 3864.409, -1999.869, 44.695, 0, 0, 180)
		moveObject(boxobj29, 10000, 3864.409, -1999.869, 44.685, 0, 0, 180)
		setTimer(cross5, 11000, 1)
	else
		moveObject(boxobj23, 2000, 3864.409, -1999.869, 2.5, 0, 0, 180)
		moveObject(boxobj24, 2000, 3864.409, -1999.869, 2.49, 0, 0, 180)
		moveObject(boxobj25, 2000, 3864.409, -1999.869, 2.48, 0, 0, 180)
		moveObject(boxobj26, 2000, 3864.409, -1999.869, 2.47, 0, 0, 180)
		moveObject(boxobj27, 2000, 3864.409, -1999.869, 2.46, 0, 0, 180)
		moveObject(boxobj28, 2000, 3864.409, -1999.869, 2.45, 0, 0, 180)
		moveObject(boxobj29, 2000, 3864.409, -1999.869, 2.44, 0, 0, 180)
		setTimer(cross5, 3000, 1, true)
	end
end
addEventHandler("onClientResourceStart", resourceRoot, start)